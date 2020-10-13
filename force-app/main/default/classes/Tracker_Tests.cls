@isTest
private with sharing class Tracker_Tests 
{
    static testMethod void validateChatterPost()
    {
        //Insert an account
        Account objAccount = new Account();
        objAccount.Name = 'test account';
        INSERT objAccount;
        
        //Insert the contact
        Contact objContact = new Contact();
        objContact.LastName = 'Tracker';
        objContact.AccountId = objAccount.Id;
        INSERT objContact;
        
        //Insert a Work Order
        WorkOrder objWO = new WorkOrder();
        objWO.Subject = 'test WO';
        objWO.AccountId = objAccount.id;
        objWO.ContactId = objContact.ID;
        INSERT objWO;
        
        //Insert a Service Appointment
        ServiceAppointment objSA = new ServiceAppointment();
        objsa.EarliestStartTime = datetime.now();
        objSA.DueDate = datetime.now().adddays(7);
        objSA.ParentRecordId = objWO.Id;
        objSA.Subject = 'test sa';
        objSA.Duration = 1;
        objSA.DurationType = 'Hours';
        objSA.Status = 'None';
        INSERT objSA;
        
        //Insert Resource
        ServiceResource objSR = new ServiceResource();
        objSR.Name = 'Test Resource';
        objSR.ResourceType = 'T';
        objSR.IsActive = true;
        objSR.RelatedRecordId = UserInfo.getUserId();
        objSR.Tracker_Contact__c = objContact.Id;
        Insert objSR;
        
        Tracker_ChatterPost.chatterSAActionRequest request = new Tracker_ChatterPost.chatterSAActionRequest();
        request.objContact = objContact;
        request.objSA = objSA;
        request.strNote = 'test note';
        List<Tracker_ChatterPost.chatterSAActionRequest> requests = new List<Tracker_ChatterPost.chatterSAActionRequest>();
        requests.add(request);
        List<String> objStrings = Tracker_ChatterPost.createSA(requests);
        
        System.assertNotEquals(objStrings.size(), 2);
        
    }
    
    static testMethod void validateConvertDT()
    {
        //Insert an account
        Account objAccount = new Account();
        objAccount.Name = 'test account';
        INSERT objAccount;
        
        //Insert the contact
        Contact objContact = new Contact();
        objContact.LastName = 'Tracker';
        objContact.AccountId = objAccount.Id;
        INSERT objContact;
        
        //Insert operating hours
        OperatingHours objOH = new OperatingHours();
        objOH.Name = 'test OH';
        objOH.TimeZone = 'America/Los_Angeles';
        INSERT objOH;
        
        //Insert TimeSlots
        List<TimeSlot> objTimeSlots = new List<TimeSlot>();
        List<String> daysofWeek = (new List<String>{'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'});
        for (string dayofweek : daysofWeek)
        {
            TimeSlot currTS = new TimeSlot();
            currTS.DayOfWeek = dayofweek;
            currTS.StartTime = Time.newInstance(9, 0, 0, 0);
            currTS.EndTime = Time.newInstance(18, 0, 0, 0);
            currTs.OperatingHoursId = objOH.Id;
            currTS.Type = 'Normal';
            objTimeSlots.add(currTS);
        }
        INSERT objTimeSlots;
        
        //Insert ST
        ServiceTerritory objT = new ServiceTerritory();
        objT.Name = 'test terr';
        objT.OperatingHoursId = objOH.id;
        objT.IsActive = true;
        insert objT;
        
        Tracker_ConvertDT.convertDTRequest request = new Tracker_ConvertDT.convertDTRequest();
        request.territoryId = objT.Id;
        request.inDT = DateTime.now();
        
        List<Tracker_ConvertDT.convertDTRequest> requests = new List<Tracker_ConvertDT.convertDTRequest>();
        requests.add(request);
        
        List<Tracker_ConvertDT.convertDTResponse> testResponse = Tracker_ConvertDT.convertDT(requests);
        
        System.assertEquals(testResponse.size(), 1);
        
    }
    
    static testMethod void validatefillIn()
    {
        //Insert an account
        Account objAccount = new Account();
        objAccount.Name = 'test account';
        INSERT objAccount;
        
        //Insert the contact
        Contact objContact = new Contact();
        objContact.LastName = 'Tracker';
        objContact.AccountId = objAccount.Id;
        INSERT objContact;
        
        Tracker_FillInSchedule.sendFISRequest request = new Tracker_FillInSchedule.sendFISRequest();
        request.PolicyName = 'test';
        request.objContact = objContact;
        List<Tracker_FillInSchedule.sendFISRequest> requests = new List<Tracker_FillInSchedule.sendFISRequest>();
        requests.add(request);
        List<String> results = Tracker_FillInSchedule.sendFIS(requests);
        System.assertEquals(results.size(), 1);
    }
    
    static testMethod void validateGetApptStatus()
    {
        //Insert an account
        Account objAccount = new Account();
        objAccount.Name = 'test account';
        INSERT objAccount;
        
        //Insert a Service Appointment
        ServiceAppointment objSA = new ServiceAppointment();
        objsa.EarliestStartTime = datetime.now();
        objSA.DueDate = datetime.now().adddays(7);
        objSA.ParentRecordId = objAccount.Id;
        objSA.Subject = 'test sa';
        objSA.Duration = 1;
        objSA.DurationType = 'Hours';
        objSA.Status = 'None';
        INSERT objSA;
        
        //Get operating hours
        OperatingHours objOH = new OperatingHours();
        objOH.Name = 'test OH';
        objOH.TimeZone = 'America/Los_Angeles';
        INSERT objOH;
        
        //Insert TimeSlots
        List<TimeSlot> objTimeSlots = new List<TimeSlot>();
        List<String> daysofWeek = (new List<String>{'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'});
        for (string dayofweek : daysofWeek)
        {
            TimeSlot currTS = new TimeSlot();
            currTS.DayOfWeek = dayofweek;
            currTS.StartTime = Time.newInstance(9, 0, 0, 0);
            currTS.EndTime = Time.newInstance(18, 0, 0, 0);
            currTs.OperatingHoursId = objOH.Id;
            currTS.Type = 'Normal';
            objTimeSlots.add(currTS);
        }
        INSERT objTimeSlots;
        
        
        //Insert ST
        ServiceTerritory objT = new ServiceTerritory();
        objT.Name = 'test terr';
        objT.OperatingHoursId = objOH.id;
        objT.IsActive = true;
        insert objT;
        
        //Insert the contact
        Contact objContact = new Contact();
        objContact.LastName = 'Tracker';
        objContact.AccountId = objAccount.Id;
        INSERT objContact;
        
        
        List<Tracker_GetAppointmentStatus.getStatusDialogRequest> apptStatusrequests = new List<Tracker_GetAppointmentStatus.getStatusDialogRequest>();
        Tracker_GetAppointmentStatus.getStatusDialogRequest apptStatusrequest = new Tracker_GetAppointmentStatus.getStatusDialogRequest();
        apptStatusrequest.MessagingTemplate_DeveloperName = 'testMT';
        apptStatusrequest.objContact = objContact;
        apptStatusrequest.objSA = objSA;
        apptStatusrequests.add(apptStatusrequest);
        
        List<Tracker_GetAppointmentStatus.getStatusDialogResult> objResults = Tracker_GetAppointmentStatus.getStatusDialog(apptStatusrequests);
        
        System.assert(String.isBlank(objResults[0].strError));
        
        //Now test the start time display string
        List<Tracker_UpdateDisplayStartTime.updateDisplayStartTimeRequest> dtRequests = new List<Tracker_UpdateDisplayStartTime.updateDisplayStartTimeRequest>();
        Tracker_UpdateDisplayStartTime.updateDisplayStartTimeRequest dtRequest = new Tracker_UpdateDisplayStartTime.updateDisplayStartTimeRequest();
        dtRequest.saID = objSA.Id;
        dtRequest.starttime = datetime.now();
        dtRequest.territoryId = objT.Id;
        dtRequests.add(dtRequest);
        
        List<String> dtResult = Tracker_UpdateDisplayStartTime.updateDisplayStartTime(dtRequests);
    }
    
    static testMethod void validateFLMonth()
    {
        List<Tracker_GetFirstLastMonth.getFLMonthActionResponse> results = Tracker_GetFirstLastMonth.getChosenSlots();
        System.assertEquals(results.size(), 1);
    }
}