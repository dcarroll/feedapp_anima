public class UIPluginHelper {

    public static List<UIPlugin> saveNewPlugins(List<UIPlugin> plugins) {
        for (UIPlugin plugin : plugins) {
            System.debug(JSON.serialize(new MyNewPluginSerializer(plugin)));
            String pluginJSON = JSON.serialize(new MyNewPluginSerializer(plugin));
            UIPluginHelper.upsertPlugin(pluginJSON, 'new', UserInfo.getSessionId());
        }
        return plugins;
    }
    
    public static List<UIPlugin> saveChangedPlugins(List<UIPlugin> plugins) {
        for (UIPlugin plugin : plugins) {
            System.debug(JSON.serialize(new MyChangedPluginSerializer(plugin)));
            String pluginJSON = JSON.serialize(new MyChangedPluginSerializer(plugin));
            UIPluginHelper.upsertPlugin(pluginJSON, plugin.Id, UserInfo.getSessionId());
        }
        return plugins;
    }
    
    public static void deletePlugins(List<String> pluginNames) {
        for (UIPlugin plugin : [Select Id, DeveloperName From UIPlugin Where DeveloperName in :pluginNames]) {
            UIPluginHelper.deletePlugin(plugin.Id, UserInfo.getSessionId());
        }
    }
    
    public static UIPlugin getUpdatedUIPluginRecord(UIPlugin2__c wrapper) {
        UIPlugin plugin = UIPluginHelper.createNewUIPluginRecord(wrapper);
        plugin.Id = wrapper.UIPlugin__c;
        return plugin;
    }
    
    public static UIPlugin createNewUIPluginRecord(UIPlugin2__c wrapper) {
        UIPlugin plugin = new UIPlugin();
        plugin.DeveloperName = wrapper.DeveloperName__c;
        plugin.MasterLabel = wrapper.MasterLabel__c;
        plugin.ExtensionPointIdentifier = wrapper.ExtensionPointIdentifier__c;
        plugin.IsEnabled = wrapper.IsEnabled__c;
        plugin.Source = UIPluginHelper.generateSource(wrapper);
        return plugin;
    }
    
    @Future(callout=true)
    public static void deletePlugin(string Id, string sessionId) {
        HttpRequest req = new HttpRequest();
        
        req.setMethod('DELETE');
        req.setEndpoint('https://gs0.salesforce.com/services/data/v32.0/sobjects/UiPlugin/' + Id);
        req.setHeader('Authorization', 'OAuth ' + sessionId);

        Http http = new Http();
        HttpResponse resp = http.send(req);
        System.debug(resp);
    }
    
    @Future(callout=true)
    public static void upsertPlugin(string pluginJSON, string Id, string sessionId) {
        HttpRequest req = new HttpRequest();
        if (Id == 'new') {
	        req.setMethod('POST');
	        req.setEndpoint('https://gs0.salesforce.com/services/data/v32.0/sobjects/UiPlugin');
        } else {
            req.setMethod('PUT');
	        req.setEndpoint('https://gs0.salesforce.com/services/data/v32.0/sobjects/UiPlugin/' + Id);
        }
        
        System.debug('Sending this JSON string: \n' + pluginJSON);
        req.setBody(pluginJSON);
        System.debug('Session id: ' + sessionId);
        req.setHeader('Authorization', 'OAuth ' + sessionId);
        req.setHeader('Content-Type', 'application/json');
        
        Http http = new Http();
        HttpResponse resp = http.send(req);
        System.debug(resp.getBody());
    }
    
    public class MyNewPluginSerializer {
        public String MasterLabel { get; set; }
        public String DeveloperName { get; set; }
        public Boolean IsEnabled { get; set; }
        public String ExtensionPointIdentifier { get; set; }
        public String Source { get; set; }

        public MyNewPluginSerializer(UIPlugin p) {
            this.MasterLabel = p.MasterLabel;
            this.DeveloperName = p.DeveloperName;
            this.IsEnabled = p.IsEnabled;
            this.ExtensionPointIdentifier = p.ExtensionPointIdentifier;
            this.Source = p.Source;
        }        
    }
    
    public class MyChangedPluginSerializer {
        public String MasterLabel { get; set; }
        public String DeveloperName { get; set; }
        public Boolean IsEnabled { get; set; }
        public String ExtensionPointIdentifier { get; set; }
        public String Source { get; set; }
        public String Id { get; set; }

        public MyChangedPluginSerializer(UIPlugin p) {
            this.MasterLabel = p.MasterLabel;
            this.DeveloperName = p.DeveloperName;
            this.IsEnabled = p.IsEnabled;
            this.ExtensionPointIdentifier = p.ExtensionPointIdentifier;
            this.Source = p.Source;
            this.Id = p.Id;
        }        
    }

    public static String generateSource(UIPlugin2__c wrapper) {
        List<String> xmlData = new List<String>();
        xmlData.add(wrapper.Sobject__c);
        xmlData.add(wrapper.Field__c);
        xmlData.add(wrapper.Component__c);
        xmlData.add(wrapper.Documentation__c);
        String source = String.format(UIPluginHelper.fieldExtension, xmlData);
        System.debug('Generated source: ' + source);
        return source;
    }
    
    private static String fieldExtension  = '<?xml version="1.0" encoding="UTF8"?>' +
        '<plugin bundleId="ui.fields.test" documentation="Test plugin" ' +
        'xmlns:xsi="http://www.w3.org/2001/XMLSchemainstance">' +
            '<extension point="ui.layout.fields">' +
            '<fieldRenderer ' +
                'id="plugin.demo1" ' +
                'sObjectName="{0}" ' +
                'fieldName="{1}" ' +
                'mode="VIEW" ' +
                'replaceWithComponent="{2}" ' +
                'documentation="{3}" />' +
            '</extension>' +
        '</plugin>';
}