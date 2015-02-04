library gltf_loader_utils;

import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as gl;

// errors
const MISSING_DESCRIPTION = "MISSING_DESCRIPTION";
const INVALID_PATH = "INVALID_PATH";
const INVALID_TYPE = "INVALID_TYPE";
const XMLHTTPREQUEST_STATUS_ERROR = "XMLHTTPREQUEST_STATUS_ERROR";
const NOT_FOUND = "NOT_FOUND";
// misc constants
const ARRAY_BUFFER = "ArrayBuffer";

var _streams = {},
    _streamsStatus = <String, _StreamStatus>{},
    _resources = {},
    _resourcesStatus = {};

// initialization
init() {
  _streams = {};
  _streamsStatus = {};
  _resources = {};
  _resourcesStatus = {};
}

//manage entries
_containsResource(resourceID) =>_resources.containsKey(resourceID);

_log(msg) => print(msg);

_storeResource(resourceID, resource) {
  if (resourceID == null) {
      _log("ERROR: entry does not contain id, cannot store");
      return;
  }

  if (_containsResource(resourceID)) {
      _log("WARNING: resource:"+resourceID+" is already stored, overriding");
  }

 _resources[resourceID] = resource;
}

_getResource(resourceID) => _resources[resourceID];

_loadStream(String path, String type, ProcessResourceDelegate delegate) {
  if (type == null) {
      delegate.handleError(INVALID_TYPE, null);
      return;
  }

  if (path == null) {
      delegate.handleError(INVALID_PATH);
      return;
  }

  HttpRequest.request(path, responseType: (type == ARRAY_BUFFER) ? "arraybuffer" : "text")
  .then((req) {
    delegate.streamAvailable(path, req.response);
  });
  // TODO(nfgs) - Catch errors here
  // .catchError((e) {
  //  delegate.handleError(XMLHTTPREQUEST_STATUS_ERROR, e.target.status);
  // });
}

int send = 0,
    requested = 0;

_handleRequest(Request request) {
        var resourceStatus = _resourcesStatus[request.id];
        if (resourceStatus != null) {
          _resourcesStatus[request.id]++;
        } else {
          _resourcesStatus[request.id] = 1;
        }

        var streamStatus = _streamsStatus[request.path];
        if (streamStatus != null && streamStatus.status == "loading" ) {
          streamStatus.requests.add(request);
          return;
        }

        _streamsStatus[request.path] = new _StreamStatus(status : "loading", requests : [request]);

        var processResourceDelegate = new ProcessResourceDelegate(request);

        _loadStream(request.path, request.type, processResourceDelegate);
}

class _StreamStatus {
  String status;
  List<Request> requests;
  _StreamStatus({this.status, this.requests});
}

class ProcessResourceDelegate {

  Request request;

  ProcessResourceDelegate(this.request);

  streamAvailable(path, res_) {
    _StreamStatus streamStatus = _streamsStatus[path];
    var requests = streamStatus.requests;
    requests.forEach((req_) {
      var end = (req_.range.length > 1) ? req_.range[1] : req_.range[0] + res_.length;
      print("${res_.length}[${req_.range[0]}..${(req_.range.length > 1) ? req_.range[1] : ''}]");
      var subArray;
      if (res_ is String) {
        subArray = res_.substring(req_.range[0], end);
      } else if (res_ is List) {
        subArray = res_.sublist(req_.range[0], end);
      }
      print("${subArray.length}");
      var convertedResource = req_.delegate.convert(subArray, req_.ctx);
      _storeResource(req_.id, convertedResource);
      req_.delegate.resourceAvailable(convertedResource, req_.ctx);
      --_resourcesStatus[req_.id];
    });

    _streamsStatus.remove(path);
  }


  handleError(errorCode, [info]) {
    request.delegate.handleError(errorCode, info);
  }
}

_elementSizeForGLType(glType) {
    switch (glType) {
        case gl.FLOAT:
            return Float32List.BYTES_PER_ELEMENT;
        case gl.UNSIGNED_BYTE :
            return Uint8List.BYTES_PER_ELEMENT;
        case gl.UNSIGNED_SHORT :
            return Uint16List.BYTES_PER_ELEMENT;
        case gl.FLOAT_VEC2 :
            return Float32List.BYTES_PER_ELEMENT * 2;
        case gl.FLOAT_VEC3 :
            return Float32List.BYTES_PER_ELEMENT * 3;
        case gl.FLOAT_VEC4 :
            return Float32List.BYTES_PER_ELEMENT * 4;
        case gl.FLOAT_MAT3 :
            return Float32List.BYTES_PER_ELEMENT * 9;
        case gl.FLOAT_MAT4 :
            return Float32List.BYTES_PER_ELEMENT * 16;
        default:
            return null;
    }
}

_handleWrappedBufferViewResourceLoading(WrappedBufferView wrappedBufferView, delegate, ctx) {
    var bufferView = wrappedBufferView.bufferView;
    var buffer = bufferView.buffer;
    var byteOffset = wrappedBufferView.byteOffset + bufferView.description["byteOffset"];
    var range = [byteOffset , (_elementSizeForGLType(wrappedBufferView.type) * wrappedBufferView.count) + byteOffset];
    print("['${wrappedBufferView.id}'] : offset = ${wrappedBufferView.byteOffset} + ${bufferView.description['byteOffset']} range = [$byteOffset..${range[1]}]");
    _handleRequest(new Request(
        id : wrappedBufferView.id,
        range : range,
        type : buffer.description["type"],
        path : buffer.description["path"],
        delegate : delegate,
        ctx : ctx));
}

getBuffer(WrappedBufferView wrappedBufferView, delegate, ctx) {

    var savedBuffer = _getResource(wrappedBufferView.id);
    if (savedBuffer != null) {
        return savedBuffer;
    } else {
        _handleWrappedBufferViewResourceLoading(wrappedBufferView, delegate, ctx);
    }

    return null;
}

getFile(Request request, delegate, ctx) {

    request.delegate = delegate;
    request.ctx = ctx;

    _handleRequest(new Request(
        id : request.id,
        path : request.path,
        range : [0],
        type : "text",
        delegate : delegate,
        ctx : ctx ));

    return null;
}

class Request {
  String id;
  String path;
  List range;
  String type;
  var delegate;
  var ctx;
  Request({this.id, this.path, this.range, this.type, this.delegate, this.ctx});
}

class WrappedBufferView {
 var bufferView;
 int byteOffset, byteStride, count;
 List min, max;
 String id;
 int type;
 String name;
 var data;
 WrappedBufferView({this.bufferView, this.byteOffset, this.byteStride, this.min, this.max, this.count, this.id, this.type, this.name});
}