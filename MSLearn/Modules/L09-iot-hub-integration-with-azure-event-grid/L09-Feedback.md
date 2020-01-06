PC 

01

1. Azure SHell is officially called Cloud SHell. In the docs we can navigate folks into the portal and select there as well.
    - Updated the name to "Azure Cloud Shell" - Chris P - 12/20/2019

1. You need to install az extension add --name azure-cli-iot-ext when using Cloud Shell
    - Updated the doc with instructions for this - Chris P - 12/20/2019

02

1. Add "+" Create a resource
    - Added - Chris P - 12/20/2019

1. On the Create Logic App blade, enter a globally unique name in the Registry **name** field.  *don't bold registry*
    - Fixed - Chris P - 12/20/2019

1. In the Resource group dropdown, select the AZ-220-RG resource group. **need to add "select Use Existing" Before the dropdown*
    - Added - Chris P - 12/20/2019

1. Alerts were very high. Consider longer times before message is sent or something different, because I ended up with 57 messages in a short amount of time.
    - I updated the delay to 5 seconds so only about 12 emails should be send instead - Chris P - 12/20/2019
    - I also updated the threshold to look for temperature of "> 31" to further reduce the count of email alerts sent. - Chris P - 12/23/2019
