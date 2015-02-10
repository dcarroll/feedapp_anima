({
    // Handle component initialization 
    doInit : function(component, event, helper) {
        var type = component.get("v.type");
        var types = component.get("v.types");
        var typeOpts = new Array();
    
        // Set the feed types on the ui:inputSelect component
        for (var i = 0; i < types.length; i++) {
            typeOpts.push({label: types[i], value: types[i], selected: types[i] === type});
        }
        component.find("typeSelect").set("v.options", typeOpts);
    },
    
    doneRendering: function(component, event, helper) {
        console.log("Done rendering from FeedComp");
        //$A.util.removeClass(component.getElement(), "slide"); 
        /*window.setTimeout(function () {
            $A.run(function() {
                if ($A.util.hasClass(component.getElement(), "slide")) {
                    console.log("Removing class slide from doneRendering");
                    $A.util.removeClass(component.getElement(), "slide");
                    console.log("Removing class slideout from doneRendering");
                    $A.util.removeClass(component.getElement(), "slideout");                    
                }
            });
        }, 100);*/
    },

	onChangeType : function(component, event, helper) {
        var typeSelect = component.find("typeSelect");
        var type = typeSelect.get("v.value");
        var compDef = "markup://forceChatter:feed";
        var attributes = {};
        if (type !== 'recordview') {
            component.set("v.type", type);
            attributes.values = { type: type }
        } else {
            compDef = "markup://force:recordview";
            attributes.values = { type: "FULL", recordId: "003B0000001VXqU"};
        }
		var feedContainer = component.find("feedContainer");
        var el = feedContainer.getElement();
        if ($A.util.hasClass(el, "slide")) {
            $A.util.removeClass(el, "slide");
            $A.util.addClass(el, "slideout");
        }
        //$A.run(function() {
            // Dynamically create the feed with the specified type
            $A.componentService.newComponentAsync(
                this,
                function(newcomponent){
                    var feedContainer = component.find("feedContainer");
                    feedContainer.set("v.body", newcomponent);
                    $A.util.addClass(feedContainer, "slide");
                },
                {
                    componentDef : compDef,
                    attributes : attributes
                }
            );
        //});
    }
})