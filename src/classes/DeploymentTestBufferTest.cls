@isTest
private class DeploymentTestBufferTest {
   static testMethod void myTest() {
        Test.StartTest();
        DeploymentTestBuffer.TestBuffer();
        DeploymentTestBuffer.TestBuffer2();
        DeploymentTestBuffer.TestBuffer3();
        Test.StopTest();
}
}