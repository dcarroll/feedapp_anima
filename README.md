# feedapp_anima

Simple Lightning App showing 2 things
1. How to configure a lightning project for viewing in the browser and in Salesforce1
The key is to create the FeedAppLayout as if it was the top level app component.  Make sure the layout component has interface="force:appHostable" and you can create tab for it that can be added to salesforce1.  In the top level app component, just add the layout component.

2. Animate when "navigating" from component to compoent.
