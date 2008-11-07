////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2008 Josh Tynjala
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to 
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

package com.flextoolbox.controls
{
	import com.flextoolbox.events.WireManagerEvent;
	import com.flextoolbox.managers.IWireManager;
	import com.flextoolbox.managers.WireManager;
	
	import mx.core.IFactory;
	import mx.core.UIComponent;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 * Dispatched when a registered WireJack wants to make a connection with
	 * another WireJack. Generally, compatible WireJack instances are expected
	 * to highlight themselves so that the user knows where a connection can be
	 * made.
	 * 
	 * @eventType com.flextoolbox.events.WireManagerEvent.BEGIN_CONNECTION_REQUEST
	 */
	[Event(name="beginConnectionRequest",type="com.flextoolbox.events.WireManagerEvent")]
	
	/**
	 * Dispatched when a registered WireJack wants to end a connection request.
	 * Generally, compatible WireJack instances are expected to remove their
	 * highlight at this time.
	 * 
	 * @eventType com.flextoolbox.events.WireManagerEvent.END_CONNECTION_REQUEST
	 */
	[Event(name="endConnectionRequest",type="com.flextoolbox.events.WireManagerEvent")]
	
	/**
	 * Dispatched when a connection is made between two WireJack instances. May
	 * be cancelled.
	 * 
	 * @eventType com.flextoolbox.events.WireManagerEvent.CREATE_CONNECTION
	 */
	[Event(name="createConnection",type="com.flextoolbox.events.WireManagerEvent")]
	
	/**
	 * Dispatched when a connection is deleted between two WireJack instances.
	 * 
	 * @eventType com.flextoolbox.events.WireManagerEvent.DELETE_CONNECTION
	 */
	[Event(name="deleteConnection",type="com.flextoolbox.events.WireManagerEvent")]

	/**
	 * A surface for displaying wires connecting WireJacks. By default, the main
	 * WireManager uses a layer on the PopUpManager to display its wires. A
	 * WireSurface allows developers to place wires anywhere in the display list
	 * hierarchy.
	 * 
	 * <p>To use, bind the WireSurface to a jack's <code>wireManager</code> property.</p>
	 * 
	 * @author Josh Tynjala (joshblog.net)
	 */
	public class WireSurface extends UIComponent implements IWireManager
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function WireSurface()
		{
			super();
			
			this.manager = new WireManager(this);
			this.manager.addEventListener(WireManagerEvent.BEGIN_CONNECTION_REQUEST, managerEventHandler);
			this.manager.addEventListener(WireManagerEvent.END_CONNNECTION_REQUEST, managerEventHandler);
			this.manager.addEventListener(WireManagerEvent.CREATING_CONNECTION, managerEventHandler);
			this.manager.addEventListener(WireManagerEvent.CREATE_CONNECTION, managerEventHandler);
			this.manager.addEventListener(WireManagerEvent.DELETE_CONNECTION, managerEventHandler);
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * The real wire manager.
		 */
		protected var manager:IWireManager;
		
		/**
		 * @inheritDoc
		 */
		public function get wireRenderer():IFactory
		{
			return this.manager.wireRenderer;
		}
		
		/**
		 * @private
		 */
		public function set wireRenderer(value:IFactory):void
		{
			this.manager.wireRenderer = value;
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		/**
		 * @inheritDoc
		 */
		public function registerJack(jack:WireJack):void
		{
			this.manager.registerJack(jack);
		}
		
		/**
		 * @inheritDoc
		 */
		public function deleteJack(jack:WireJack):void
		{
			this.manager.deleteJack(jack);
		}
		
		/**
		 * @inheritDoc
		 */
		public function beginConnectionRequest(startJack:WireJack):void
		{
			this.manager.beginConnectionRequest(startJack);
		}
		
		/**
		 * @inheritDoc
		 */
		public function endConnectionRequest(startJack:WireJack):void
		{
			this.manager.endConnectionRequest(startJack);
		}
		
		/**
		 * @inheritDoc
		 */
		public function connect(startJack:WireJack, endJack:WireJack):Boolean
		{
			return this.manager.connect(startJack, endJack);
		}
		
		/**
		 * @inheritDoc
		 */
		public function disconnect(startJack:WireJack, endJack:WireJack):void
		{
			this.manager.disconnect(startJack, endJack);
		}
		
	//--------------------------------------
	//  Protected Event Handlers
	//--------------------------------------
	
		/**
		 * @private
		 * Re-dispatches events from the wrapped wire manager.
		 */
		protected function managerEventHandler(event:WireManagerEvent):void
		{
			this.dispatchEvent(event);
		}
	}
}