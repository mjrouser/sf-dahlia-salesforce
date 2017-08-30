/**
 * @author:      Heidi Tang
 * @date:        12/10/2014
 * @description: A class to get file size and converted name.
 * @history:     06/11/2015 - Heidi Tang - Edited
*/
public with sharing class CS_MOHCDGetListOfAttachments {
    
	public static String convertName(String name,String description){
        name = name.replace('-'+description,'');
        return name;
    }
    
    public static String convertedSize(Long bodyLength){
        if(bodyLength < 1024){
            return bodyLength.format() + ' Bytes';
        }else{
            if(bodyLength >= 1024 && bodyLength < (1024*1024)){
                //KB
                Decimal kb = Decimal.valueOf(bodyLength);
                kb = kb.divide(1024,2);
                return kb.format() + ' KB';
            }else if(bodyLength >= (1024*1024) && bodyLength < (1024*1024*1024)){
                //MB
               Decimal mb = Decimal.valueOf(bodyLength);
               mb = mb.divide((1024*1024),2);
               return mb.format() + ' MB';
            }else{
                //GB
                Decimal gb = Decimal.valueOf(bodyLength);
                gb = gb.divide((1024*1024*1024),2);      
                return gb.format() + ' GB';
            }         
        }
    }
}