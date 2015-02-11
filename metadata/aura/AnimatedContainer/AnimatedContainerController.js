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
    
	onChangeType : function(component, event, helper) {
        var typeSelect = component.find("typeSelect");
        var type = typeSelect.get("v.value");
        var compDef = "markup://forceChatter:feed";
        var attributes = {};
        var animation_in = component.get("v.animation-in");
        var animation_out = component.get("v.animation-out");
        if (type === 'Record View') {
            compDef = "markup://force:recordview";
            attributes.values = { type: "FULL", recordId: "003B0000001VXqU"};
        } else if (type === 'Contact List') {
            compDef = "markup://dip:ContactList";
        } else {
            component.set("v.type", type);
            attributes.values = { type: type }
        }
		var feedContainer = component.find("feedContainer");
        var el = feedContainer.getElement();
        if ($A.util.hasClass(el, animation_in)) {
            $A.util.removeClass(el, animation_in);
            $A.util.addClass(el, animation_out);
        } 
        
        $A.componentService.newComponentAsync(
            this,
            function(newcomponent){
                var feedContainer = component.find("feedContainer");
                feedContainer.set("v.body", newcomponent);
                $A.util.addClass(feedContainer, animation_in);
            },
            {
                componentDef : compDef,
                attributes : attributes
            }
        );
    }
})