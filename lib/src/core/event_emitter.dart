part of three;

class EventEmitterEvent {
  String type;
  String message;
  var content;
  EventEmitterEvent({this.type, this.message, this.content});
}

class EventEmitter {

	var listeners;

	EventEmitter() : listeners = {};

	addEventListener( type, listener ) {

		if ( listeners[ type ] == null ) {
			listeners[ type ] = [];
		}

		if ( listeners[ type ].indexOf( listener ) == - 1 ) {
			listeners[ type ].add( listener );
		}

	}

	dispatchEvent( event ) {
		if ( listeners[ event.type ] != null ) {
			listeners[ event.type ].forEach((listener) => listener( event ));
		}
	}

	removeEventListener ( type, listener ) {

		var index = listeners[ type ].indexOf( listener );

		if ( index != - 1 ) {
			listeners[ type ].removeAt( index );
		}

	}

}
