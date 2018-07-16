public class BitcoinPriceCalculation implements HyperBatch {

    public HyperBatchObjects.HyperBatchStart start() {
        String query = 
        'SELECT Id, Close__c, High__c, Low__c, Open__c, Time__c, Timestamp__c, Volume_BTC__c, Volume_Currency__c, Weighted_Price__c ' +
        'FROM Bitcoin_Price__c';        
        return new HyperBatchObjects.HyperBatchStart('Bitcoin_Price__c', query);       
    }    
    
    public Object execute(List<sObject> scope) {
		Map<String, Map<String, Decimal>> dayOfWeekMap = new Map<String, Map<String, Decimal>>();

        for(sObject s: scope) {
            Bitcoin_Price__c b = (Bitcoin_Price__c)s;
            String dayOfWeek = b.Time__c.format('EEEE');
            if (!dayOfWeekMap.containsKey(dayOfWeek)) {
                dayOfWeekMap.put(dayOfWeek, new Map<String, Decimal>{'spread'=> 0, 'count' => 0});
            }
            Map<String, Decimal> tempMap = dayOfWeekMap.get(dayOfWeek);
            Decimal spread = tempMap.get('spread');
            Decimal count = tempMap.get('count');
            spread += (b.High__c - b.Low__c);
            count++;
            tempMap.put('spread', spread);
            tempMap.put('count', count);
            dayOfWeekMap.put(dayOfWeek, tempMap);
        }
            
		return dayOfWeekMap;        
    }
    
    public void finish(List<Object> state) {
		
        //add all the maps up from the executes
        Map<String, Map<String, Decimal>> dayOfWeekMapFinish = new Map<String, Map<String, Decimal>>();
        for (Object o: state) {
            //Map<String, Map<String, Decimal>> dayOfWeekMap = (Map<String, Map<String, Decimal>>)o;
            
            Map<String, Object> dayOfWeekObjMap = (Map<String, Object>)o;            
            
            for (String dayOfWeek: dayOfWeekObjMap.keySet()) {
                Map<String, Object> tempMapObj = (Map<String, Object>)dayOfWeekObjMap.get(dayOfWeek);
                Decimal spread = (Decimal)tempMapObj.get('spread');
                Decimal count = (Decimal)tempMapObj.get('count');

                
                if (!dayOfWeekMapFinish.containsKey(dayOfWeek)) {
                    dayOfWeekMapFinish.put(dayOfWeek, new Map<String, Decimal>{'spread'=> 0, 'count' => 0});
                }                
                Map<String, Decimal> tempMapFinish = dayOfWeekMapFinish.get(dayOfWeek);
                Decimal spreadFinish = tempMapFinish.get('spread');
                Decimal countFinish = tempMapFinish.get('count');

                spreadFinish += spread;
                countFinish += count;

                tempMapFinish.put('spread', spreadFinish);
                tempMapFinish.put('count', countFinish);                

                dayOfWeekMapFinish.put(dayOfWeek, tempMapFinish);                
            }
        }
        
        //now go through and average them
        List<DaysVolatility> dvList = new List<DaysVolatility>();
		for (String dayOfWeek: dayOfWeekMapFinish.keySet()) {        
        	Map<String, Decimal> tempMap = dayOfWeekMapFinish.get(dayOfWeek);
            Decimal spread = tempMap.get('spread');
            Decimal count = tempMap.get('count');            
            Decimal avg = (spread / count);
            dvList.add(new DaysVolatility(dayOfWeek, avg));
        }    
        dvList.sort();
		Eventbus.publish(new Bitcoin_Calculation__e(Data__c=JSON.serialize(dvList)));
    }   
    
    
    Class DaysVolatility implements Comparable {
        
        public String dayOfWeek {get; set;}
        public Decimal volatility {get; set;}        

        public DaysVolatility(String d, Decimal v) {
            dayOfWeek = d;
            volatility = v;
        }
        
        public Integer compareTo(Object compareTo) {
            DaysVolatility compareToDV = (DaysVolatility)compareTo;
            if (volatility == compareToDV.volatility) return 0;
            if (volatility > compareToDV.volatility) return 1;
            return -1;        
        }
    }    
    
    
    
    
    
}