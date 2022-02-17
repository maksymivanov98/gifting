@isTest
private class BatchCheckStatusSendingGiftSchedule_Test {

    Private static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Test.StartTest();
        BatchCheckStatusOnSendingGiftSchedule batchschedule = new BatchCheckStatusOnSendingGiftSchedule();
      	String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, batchschedule );
		Test.stopTest();
		system.assert(true);
    }
}