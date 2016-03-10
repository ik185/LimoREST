public with sharing class ViewToursController {
    private ApexPages.StandardController controller {get; set;}
    public ToursRESTApi api { get; set; }
    public String curAccountID { get; set; }

    public ViewToursController(ApexPages.StandardController controller) {

        this.controller = controller;
        Case c = (Case)controller.getRecord();

        this.curAccountID = [SELECT AccountID FROM Case WHERE Id = :c.Id].AccountID;

    }

    public void getToursList() {
        if(curAccountID != null) {
            api = new ToursRESTApi();
            api.getTours(curAccountID);
            if(api.errorResult != null) {
                ApexPages.Message myMsgError = new ApexPages.Message(ApexPages.Severity.Error,api.errorResult.errorMessage);
                ApexPages.addMessage(myMsgError);            
            }
        } 
        else {
            ApexPages.Message myMsgInfo = new ApexPages.Message(ApexPages.Severity.Info,'Please, specify Account to display Tours');
            ApexPages.addMessage(myMsgInfo);
        }
    }
}