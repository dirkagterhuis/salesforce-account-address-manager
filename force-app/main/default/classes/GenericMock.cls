public class GenericMock implements System.StubProvider {
    public Map<String, Object> returns = new Map<String, Object>();
    public Map<String, Integer> callCount = new Map<String, Integer>();
    public Map<String, List<Object>> args = new Map<String, List<Object>>();

    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs) {
        if (!callCount.containsKey(stubbedMethodName)) {
            callCount.put(stubbedMethodName, 0);
        }
        callCount.put(stubbedMethodName, callCount.get(stubbedMethodName) + 1);
        if (!args.containsKey(stubbedMethodName)) {
            args.put(stubbedMethodName, new List<Object>());
        }
        args.put(stubbedMethodName, listOfArgs);
        return returns.get(stubbedMethodName);
    }
}