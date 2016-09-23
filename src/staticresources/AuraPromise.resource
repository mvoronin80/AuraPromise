/*
 * Promises support for Aura framework
 */
(function(w){ 
    /*
    	Internal method for getting error message
    */
    var _getErrorDescription = function(errors) {
        if (errors) { 
            if (errors[0] && errors[0].message) {
               return errors[0].message;
            }
        } else {
            return "Unknown error";
        }
	}
    
    /*
     * Wait promise wrapper
     */ 
	var _wait = function(timeout, component, passthrough) {
    	return new Promise(function(resolve, reject) {
            setTimeout(
                function() {
                    if (component.isValid()) {
                        resolve(passthrough);
                    }
    			}
                , 
                timeout); 
        });
    }
    
    /* 
     * Remote call promise wrapper 
    */
    var _serverSideCall = function(action, component) {
        return new Promise(function(resolve, reject) { 
            action.setCallback(this, 
            	function(response) {
                	var state = response.getState();
                    if (component.isValid() && state === "SUCCESS") {
                    	resolve(response.getReturnValue());
                    } else if (component.isValid() && state === "ERROR") {
                        reject(new Error(_getErrorDescription(response.getError())));
                    }
                }); 
            $A.enqueueAction(action);
        });
    }

	// async while decorator
	function generate(Promise) {       
        return function(condition, action, ctx) {
            var whileFunction = function(data) {
                try {
                    // set context to local this
                    if (ctx == null) 
                        ctx = this;
                    // if condition is not met - exit promise chain
                    if (!condition.call(ctx, data)) 
                        return Promise.resolve(data);
                    // if condition is met call action methon and chain promise to "whileFunction"
                    return Promise.resolve(action.call(ctx, data)).then(whileFunction);
                } catch(e) {
                    return Promise.reject(e);
                }
            };
            return whileFunction;
        };
    }
    // get aysnc while function
    var asyncWhile = generate(Promise);
    // append it to Promise and its prototype
    Promise.while = function() {
        return asyncWhile.apply(this, arguments)();
    }
    Promise.prototype.while = function() {
        return this.then(asyncWhile.apply(this, arguments));
    }
        
    // export module returns
    w.AuraPromise = {
         wait: _wait,
         serverSideCall: _serverSideCall
    }                          
})(window);