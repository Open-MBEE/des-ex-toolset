/**
 * @name returnSubElements
 * @description returns all sub elements of a given model element
 * @param {ALH model element} element - element to be searched
 *
 * @returns {object} list containing all sub elements and number of sub elements
 */
function returnSubElements(element) {
    KeyCount = 0;
    elementstr= String(element);
    fullsplit = elementstr.split('['); //'['
    NoKeys = fullsplit.length

    elementlist = ALH.createList();
    Noelements = 0;

    keylist= ALH.createList();

    while (NoKeys > KeyCount){
        // catch case wehre port instances hide sub element
        if (fullsplit[KeyCount].split('=').length > 2){
            local_split = fullsplit[KeyCount].split("=");
            namekey = String(local_split[local_split.length - 2]);

            // removing preceeding and trailing spaces
            namekey = namekey.slice(4,namekey.length-1)
        }
        else{
            namekey = String(fullsplit[KeyCount].split('=')[0]);
            // removing previous name key type
            if (namekey.search("]") != -1){
                namekey = namekey.split("]")[1]
            }

            // removing next key name
            if (namekey.search("{") != -1){
                namekey = namekey.split("{")[1]
            }

            // removing preceeding and trailing spaces
            namekey = namekey.slice(3,namekey.length-1)
        }


        if (namekey != ""){
        keylist.add(String(namekey));
        err = [];
        try {   
              subelement = ALH.getValue(element, namekey);
              if (String(subelement) != "null"){
              Noelements = Noelements + 1;
              }
              elementlist.add(subelement);

        }
        catch(err) {
            
        }
        }
    KeyCount = KeyCount + 1;
    }


    return {
        'Noelements': Noelements,
        'elementlist': elementlist,
        'error': err
      };
}

/**
 * @name returnSubPropeties
 * @description returns all sub propeties of a given model element
 * @param {ALH model element} element - element to be searched
 *
 * @returns {object} list containing all sub propeties and number of sub elements
 */
function returnSubPropeties(element){
    KeyCount = 0;
    elementstr= String(element);
    fullsplit = elementstr.split('=');
    NoKeys = fullsplit.length

    proplist = ALH.createList();
    Noprops = 0;

    keylist= ALH.createList();
    triednamekeys = ALH.createList();
    ognk = ALH.createList();

    while (NoKeys > KeyCount){
        // added check to avoid erroneously picking elements, not values
        try {
            nextkeycheck = String(fullsplit[KeyCount+1]).search('@');
        }
        catch (ERROR) {
            nextkeycheck = -1;
        }

        if (nextkeycheck == -1){
            namekey = String(fullsplit[KeyCount].split('=')[0]);
        }
        else {
            namekey = "";
        }
        // removing previous name key type
        if (namekey.search("]") != -1){
            namekey = namekey.split("]")[1]
        }

        // removing next key name
        if (namekey.search("{") != -1){
            namekey = namekey.split("{")[1]
        }

        // removing preceding and trailing spaces
        namekey = namekey.slice(3,namekey.length-1)
        err = [];
        if (namekey != ""){
        keylist.add(String(namekey));
        try {
              subelement = ALH.getValue(element, namekey);

              if (String(subelement).search('@') == -1){
              Noprops = Noprops + 1;
              proplist.add(namekey);
              }
              triednamekeys.add(namekey);
              ognk.add(String(fullsplit[KeyCount].split('=')[0]));


        }
        catch(err) {

        }

        }
        KeyCount = KeyCount + 1;
    }


    return {
        'Noprops': Noprops,
        'proplist': proplist,
        'error': err,
        'fullsplit': fullsplit,
        'triednamekeys': triednamekeys,
        'ognk':ognk
      };
}

/**
 * @name checknoisefactorstatus
 * @description checks if noise factor is enabled and returns the recurring the list of noise factors
 * @param {ALH model element} element - element to be checked for noise factor status
 * @param {list} noisefactorlist - list of identified noise factors
 *
 * @returns {list} noisefactorlist - updated list of identified noise factors
 */
function checknoisefactorstatus(element,noisefactorlist){
    try {
        noisefactorenabled =  ALH.getTagValue(element,"Enable Noise Factor");
        if(String(noisefactorenabled) == "true"){
            noisefactorlist.add(element);
        }
    }
    catch(ERROR) {
    }
    return noisefactorlist;
}

/**
 * @name checkresponseparameterstatus
 * @description checks if response parameter is enabled and returns the recurring the list of response parameters
 * @param {ALH model element} element - element to be checked for response parameter status
 * @param {list} responseparameterlist - list of identified response parameters
 *
 * @returns {list} responseparameterlist - updated list of identified response parameters
 */
function checkresponseparameterstatus(element,responseparameterlist){
    try {
        responseparameterenabled =  ALH.getTagValue(element,"Enable System Response Parameter");
        if(String(responseparameterenabled) == "true"){
            responseparameterlist.add(element);
        }
    }
    catch(ERROR) {
    }
    return responseparameterlist;
}

/**
 * @name checkdesignvariablestatus
 * @description checks if design variable is enabled and returns the recurring the list of design variables
 * @param {ALH model element} element - element to be checked for design variable status
 * @param {list} designvarlist - list of identified design variables
 *
 * @returns {list} designvarlist - updated list of identified design variables
 */
function checkdesignvariablestatus(element,designvarlist){
try {
    designvariableenabled =  ALH.getTagValue(element,"Enable Design Variable");
    if(String(designvariableenabled) == "true"){
        designvarlist.add(element);
    }
}
catch(ERROR) {
}
return designvarlist;
}

/**
 * @name checkdependantvariablestatus
 * @description checks if dependant variable is enabled and returns the recurring the list of dependant variables
 * @param {ALH model element} element - element to be checked for dependant variable status
 * @param {list} dependantvarlist - list of identified dependant variables
 *
 * @returns {list} dependantvarlist - updated list of identified dependant variables
 */
function checkdependantvariablestatus(element,dependantvarlist){
    try {
        dependantvariableenabled =  ALH.getTagValue(element,"Enable Dependant Variable");
        if(String(dependantvariableenabled) == "true"){
            dependantvarlist.add(element);
        }
    }
    catch(ERROR) {

    }
    return dependantvarlist;
}

/**
 * @name checkobjectivestatus
 * @description checks if objective is enabled and returns the recurring the list of objectives
 * @param {ALH model element} element - element to be checked for objective status
 * @param {list} objectivelist - list of identified objectives
 *
 * @returns {list} objectivelist - updated list of identified objectives
 */
function checkobjectivestatus(element,objectivelist){
    try {
        objectiveenabled =  ALH.getTagValue(element,"Enable Objective");
        if(String(objectiveenabled) == "true"){
            objectivelist.add(element);
        }
    }
    catch(ERROR) {

    }
    return objectivelist;
}

/**
 * @name checkrequirementconstraintstatus
 * @description checks if requirement constraint is enabled and returns the recurring the list of requirement constraints
 * @param {ALH model element} element - element to be checked for requirement constraint status
 * @param {list} requirementconstraintlist - list of identified requirement constraints
 *
 * @returns {list} requirementconstraintlist - updated list of identified objectives
 */
function checkrequirementconstraintstatus(element,requirementconstraintlist){
    try {
        requirementconstraintenabled =  ALH.getValue(element,"ConstraintTestValue");
        if (requirementconstraintenabled != null){
            requirementconstraintlist.add(element);
        }
    }
    catch(ERROR) {

    }
    return requirementconstraintlist;
}

/**
 * @name getdesignvariablemin
 * @description returns design variable minimum value
 * @param {ALH model element} element - design variable element
 * @param {list} designvarminlist - list of identified design variable minimums
 *
 * @returns {list} designvarminlist - updated list of identified design variable minimums
 */
function getdesignvariablemin(element,designvarminlist){
try {
    designvariableenabled =  ALH.getTagValue(element,"Enable Design Variable");
    if(String(designvariableenabled) == "true"){
        designvarminlist.add(ALH.getTagValue(element,"Design Variable Minimum"));
    }
}
catch(ERROR) {
}
return designvarminlist;
}

/**
 * @name getdesignvariablemax
 * @description returns design variable maximum value
 * @param {ALH model element} element - design variable element
 * @param {list} designvarmaxlist - list of identified design variable maximums
 *
 * @returns {list} designvarmaxlist - updated list of identified design variable maximums
 */
function getdesignvariablemax(element,designvarmaxlist){
try {
    designvariableenabled =  ALH.getTagValue(element,"Enable Design Variable");
    if(String(designvariableenabled) == "true"){
        designvarmaxlist.add(ALH.getTagValue(element,"Design Variable Maximum"));
    }
}
catch(ERROR) {
}
return designvarmaxlist;
}

/**
 * @name getdesignvariablenopoints
 * @description returns design variable number of test points
 * @param {ALH model element} element - design variable element
 * @param {list} designvarnopointslist - list of identified design variable number of test points
 *
 * @returns {list} designvarnopointslist - updated list of identified design variable number of test points
 */
function getdesignvariablenopoints(element,designvarnopointslist){
try {
    designvariableenabled =  ALH.getTagValue(element,"Enable Design Variable");
    if(String(designvariableenabled) == "true"){
        designvarnopointslist.add(ALH.getTagValue(element,"Number of Design Variable Collection Points"));
    }
}
catch(ERROR) {
}

return designvarnopointslist;
}

/**
 * @name getdesignvariableaddress
 * @description returns design variable address
 * @param {ALH model element} element - design variable element
 * @param {list} elementaddr - address of current element
 * @param {list} designvaraddr - list of identified design variable addresses
 *
 * @returns {list} designvaraddrlist - updated list of identified design variable addresses
 */
function getdesignvariableaddress(element,elementaddr,designvaraddrlist){
    try {
        designvariableenabled =  ALH.getTagValue(element,"Enable Design Variable");
        if(String(designvariableenabled) == "true"){
            designvaraddrlist.add(String(elementaddr));
        }
    }
    catch(ERROR) {

    }
    return designvaraddrlist;
}

/**
 * @name getDesignSpaceVariableElementName
 * @description returns design variable name
 * @param {ALH model element} element - design variable element
 *
 * @returns {string} designvarname - name of design variable
 */
function getDesignSpaceVariableElementName(element){
    try {
        designvarname = ALH.getTagValue(element,"Variable Name");
    }
    catch(ERROR) {

    }
    return designvarname;
}

/**
 * @name sendDesignSpaceVariableNameToMatlab
 * @description sends the design variable name to the matlab workspace
 * @param {ALH model element} element - design variable element
 *
 */
function sendDesignSpaceVariableNameToMatlab(element){
    Name = getDesignSpaceVariableElementName(element)

    expressionstring = "exist('Cameonamestrings');";
    exist = ALH.evaluate("MATLAB",expressionstring);

    if (exist==false){
        expressionstring = 'Cameonamestrings = "";';
        exist = ALH.evaluate("MATLAB",expressionstring);
    }

    expressionstring = "Cameonamestrings(end+1) = '";
    expressionstring = expressionstring.concat(String(Name),"';");
    ALH.evaluate("MATLAB",expressionstring);

}

/**
 * @name getnoisefactoraddress
 * @description returns noise factor address
 * @param {ALH model element} element - noise factor element
 * @param {list} elementaddr - address of current element
 * @param {list} elementaddr - list of identified noise factor addresses
 *
 * @returns {list} noisefactoraddrlist - updated list of identified noise factor addresses
 */
function getnoisefactoraddress(element,elementaddr,noisefactoraddrlist){
    try {
        noisefactorenabled =  ALH.getTagValue(element,"Enable Noise Factor");
        if(String(noisefactorenabled) == "true"){
            noisefactoraddrlist.add(String(elementaddr));
        }
    }
    catch(ERROR) {

    }
    return noisefactoraddrlist;
}

/**
 * @name getresponseparameteraddress
 * @description returns response parameter address
 * @param {ALH model element} element - response parameter element
 * @param {list} elementaddr - address of current element
 * @param {list} elementaddr - list of identified response parameter addresses
 *
 * @returns {list} responseparameteraddrlist - updated list of identified response parameter addresses
 */
function getresponseparameteraddress(element,elementaddr,responseparameteraddrlist){
    try {
        responseparameterenabled =  ALH.getTagValue(element,"Enable System Response Parameter");
        if(String(responseparameterenabled) == "true"){
            responseparameteraddrlist.add(String(elementaddr));
        }
    }
    catch(ERROR) {

    }
    return responseparameteraddrlist;
}

/**
 * @name getdependantvariableaddress
 * @description returns dependant variable address
 * @param {ALH model element} element - dependant variable element
 * @param {list} elementaddr - address of current element
 * @param {list} elementaddr - list of identified dependant variable addresses
 *
 * @returns {list} dependantvariableaddrlist - updated list of identified dependant variable addresses
 */
function getdependantvariableaddress(element,elementaddr,dependantvaraddrlist){
    try {
        dependantvariableenabled =  ALH.getTagValue(element,"Enable Dependant Variable");
        if(String(dependantvariableenabled) == "true"){
            dependantvaraddrlist.add(String(elementaddr));
        }
    }
    catch(ERROR) {

    }
    return dependantvaraddrlist;
}

/**
 * @name getobjectiveaddress
 * @description returns objective address
 * @param {ALH model element} element - objective element
 * @param {list} elementaddr - address of current element
 * @param {list} elementaddr - list of identified objective addresses
 *
 * @returns {list} objectiveaddrlist - updated list of identified objective addresses
 */
function getobjectiveaddress(element,elementaddr,objectiveaddrlist){
    try {
        objectiveenabled =  ALH.getTagValue(element,"Enable Objective");
        if(String(objectiveenabled) == "true"){
            objectiveaddrlist.add(String(elementaddr));
        }
    }
    catch(ERROR) {

    }
    return objectiveaddrlist;
}

/**
 * @name getobjectiveweight
 * @description returns objective weight
 * @param {ALH model element} element - objective element
 * @param {list} objectiveweightlist - list of identified objective weights
 *
 * @returns {list} objectiveweightlist - updated list of identified objective weights
 */
function getobjectiveweight(element,objectiveweightlist){
    try {
        objectiveenabled =  ALH.getTagValue(element,"Enable Objective");
        if(String(objectiveenabled) == "true"){
            objectiveweightlist.add(Number(ALH.getTagValue(element,"Weight")));
        }
    }
    catch(ERROR) {

    }
    return objectiveweightlist;
}

/**
 * @name convertStringtojavalist
 * @description converts string to java list
 * @param {string} stringin - string to be converted
  *
 * @returns {list} arrayout - output java list
 */
function convertStringtojavalist(stringin){
    // removing preceeding and trailing square brackets
    stringin = stringin.slice(1,stringin.length-1)
    fullsplit = stringin.split(',');
    Noelements = fullsplit.length
    elementCount =  0;

    arrayout = [];

    while (Noelements > elementCount){
        element = String(fullsplit[elementCount]);


        if (element != ""){


            try {
                  arrayout.push(Number(element));
            }
            catch(err) {

            }

        }
        elementCount = elementCount + 1;
    }
    return  arrayout
}

/**
 * @name returnnoisefactorvalue
 * @description returns noise factor value
 * @param {ALH model element} element - noise factor element
 *
 * @returns {list} elementlist - list of identified noise factor values
 */
function returnnoisefactorvalue(element) {
    KeyCount = 0;
    elementstr= String(element);
    fullsplit = elementstr.split('=');
    NoKeys = fullsplit.length

    elementlist = [];

    keylist= ALH.createList();

    while (NoKeys > KeyCount){
        namekey = fullsplit[KeyCount];

        if (namekey.search("]") != -1){
            // removing preceeding and trailing brackets
            namekey = namekey.slice(2,namekey.length-3)
            elementlist.push(Number(namekey));
        }
        KeyCount++;
    }
    return elementlist;
}

/**
 * @name returnresponseparametervalue
 * @description returns response parameter value
 * @param {ALH model element} element - response parameter element
 *
 * @returns {list} elementlist - list of identified response parameter values
 */
function returnresponseparametervalue(element) {
    KeyCount = 0;
    elementstr= String(element);
    fullsplit = elementstr.split('=');
    NoKeys = fullsplit.length

    elementlist = [];

    keylist= ALH.createList();

    while (NoKeys > KeyCount){
    namekey = fullsplit[KeyCount];

        if (namekey.search("]") != -1){
            // removing preceeding and trailing brackets
            namekey = namekey.slice(2,namekey.length-3)
            elementlist.push(Number(namekey));
        }
        KeyCount++;
    }
    return elementlist;
}

/**
 * @name returndesignvarvalue
 * @description returns design variable value
 * @param {ALH model element} element - design variable element
 *
 * @returns {list} elementlist - list of identified design variable values
 */
function returndesignvarvalue(element) {
    KeyCount = 0;
    elementstr= String(element);
    fullsplit = elementstr.split('=');
    NoKeys = fullsplit.length

    elementlist = [];

    keylist= ALH.createList();

    while (NoKeys > KeyCount){
        namekey = fullsplit[KeyCount];

        if (namekey.search("]") != -1){
            // removing preceeding and trailing brackets
            namekey = namekey.slice(2,namekey.length-3)
            elementlist.push(Number(namekey));
        }
        KeyCount++;
    }
    return elementlist;
}

/**
 * @name returndesignvarvaluename
 * @description returns design variable value name
 * @param {ALH model element} element - design variable element
 *
 * @returns {list} elementlist - list of identified design variable value names
 */
function returndesignvarvaluename(element) {
    KeyCount = 0;
    elementstr= String(element);
    fullsplit = elementstr.split('=');
    NoKeys = fullsplit.length

    elementlist = [];

    keylist= ALH.createList();

    while (NoKeys > KeyCount){
        namekey = fullsplit[KeyCount];

        if (namekey.search("]") == -1){
            // removing type and instance tags
            namekey = namekey.split(' ')[1];
            // removing preceeding and trailing brackets
            namekey = namekey.slice(4,namekey.length);
            elementlist.push(String(namekey));
        }
        KeyCount++;
    }
    return elementlist;
}

/**
 * @name returndependantvarvalue
 * @description returns dependant variable value
 * @param {ALH model element} element - dependant variable element
 *
 * @returns {list} elementlist - list of identified dependant variable value
 */
function returndependantvarvalue(element) {
    KeyCount = 0;
    elementstr= String(element);
    fullsplit = elementstr.split('=');
    NoKeys = fullsplit.length

    elementlist = [];

    keylist= ALH.createList();

    while (NoKeys > KeyCount){
    namekey = fullsplit[KeyCount];

    if (namekey.search("]") != -1){
    // removing preceeding and trailing brackets
    namekey = namekey.slice(2,namekey.length-3)
    elementlist.push(Number(namekey));
    }
    KeyCount++;
    }
    return elementlist;
}

/**
 * @name returnobjectivevalue
 * @description returns objective value
 * @param {ALH model element} element - objective element
 *
 * @returns {list} elementlist - list of identified objective value
 */
function returnobjectivevalue(element) {
    KeyCount = 0;
    elementstr= String(element);
    fullsplit = elementstr.split('=');
    NoKeys = fullsplit.length

    elementlist = [];

    keylist= ALH.createList();

    while (NoKeys > KeyCount){
    namekey = fullsplit[KeyCount];

    if (namekey.search("]") != -1){
    // removing preceeding and trailing brackets
    namekey = namekey.slice(2,namekey.length-3)
    elementlist.push(Number(namekey));
    }
    KeyCount++;
    }
    return elementlist;
}

/**
 * @name returnobjectivevaluename
 * @description returns objective value name
 * @param {ALH model element} element - objective element
 *
 * @returns {list} elementlist - list of identified objective value names
 */
function returnobjectivevaluename(element) {
    KeyCount = 0;
    elementstr= String(element);
    fullsplit = elementstr.split('=');
    NoKeys = fullsplit.length

    elementlist = [];

    keylist= ALH.createList();

    while (NoKeys > KeyCount){
    namekey = fullsplit[KeyCount];

    if (namekey.search("]") == -1){
    // removing type and instance tags
    namekey = namekey.split(' ')[1];
    // removing preceeding and trailing brackets
    namekey = namekey.slice(4,namekey.length);
    elementlist.push(String(namekey));
    }
    KeyCount++;
    }
    return elementlist;
}

/**
 * @name returndesignspacevaluename
 * @description returns generic design space value name
 * @param {ALH model element} element - generic design space element
 *
 * @returns {string} valuename - list of identified generic design space value names
 */
function returndesignspacevaluename(declarationelement){
    valuename = String(ALH.getTagValue(declarationelement,"Variable Name"))
    return valuename
}

/**
 * @name returnnoisefactormean
 * @description returns noise factor mean
 * @param {ALH model element} element - noise factor element
 *
 * @returns {list} elementlist - list of identified noise factor means
 */
function returnnoisefactormean(noisefactoraddresslist){
    currElement = ContextHelper.findSessionRootObject($context$.getRefSession());
    loops = 0

    for ( i = 0; i <noisefactoraddresslist.length; i++){

        subelementset = returnSubElements(currElement);
        currElement = subelementset.elementlist[noisefactoraddresslist[i]];

        if (i == noisefactoraddresslist.length-2){
            ParentElement = currElement
        }

        loops = loops + 1;
    }

    valuename = returndesignspacevaluename(currElement);
    mean = Number(ALH.getValue(ParentElement,valuename))
    return mean
}

/**
 * @name returnresponseparametervalue
 * @description returns response parameter value
 * @param {ALH model element} element - response parameter element
 *
 * @returns {list} elementlist - list of identified response parameter values
 */
function returnresponseparametervalue(responseparameteraddresslist){
    currElement = ContextHelper.findSessionRootObject($context$.getRefSession());
    loops = 0

    for ( i = 0; i <responseparameteraddresslist.length; i++){

        subelementset = returnSubElements(currElement);
        currElement = subelementset.elementlist[responseparameteraddresslist[i]];

        if (i == responseparameteraddresslist.length-2){
            ParentElement = currElement
        }

        loops = loops + 1;
    }

    valuename = returndesignspacevaluename(currElement);
    value = Number(ALH.getValue(ParentElement,valuename))
    return value
}

/**
 * @name getlengthofembennedlist
 * @description returns length of a list embedded in another
 * @param {list} listin - input list
 *
 * @returns {int} Noelements - number of embedded elements in list
 */
function getlengthofembennedlist(listin){
    // removing preceeding and trailing square brackets
    stringin = String(listin);
    stringin = stringin.slice(1,stringin.length-1)
    fullsplit = stringin.split(',');
    Noelements = fullsplit.length
    b = Noelements

    return Noelements;
}

/**
 * @name checkgroundstationstatus
 * @description checks if ground station is enabled and returns the recurring the list of ground stations
 * @param {ALH model element} element - element to be checked for ground station status
 * @param {list} groundstationlist - list of identified ground stations
 *
 * @returns {list} groundstationlist - updated list of identified ground stations
 */
function checkgroundstationstatus(element,groundstationlist){
    try {
        groundstationenabled =  ALH.getTagValue(element,"Enable Ground Station");
        if(String(groundstationenabled) == "true"){
            groundstationlist.add(element);
        }
    }
    catch(ERROR) {
    }
    return groundstationlist;
}

/**
 * @name checkspacecraftstatus
 * @description checks if spacecraft is enabled and returns the recurring the list of spacecrafts
 * @param {ALH model element} element - element to be checked for spacecraft status
 * @param {list} spacecraftlist - list of identified spacecraft
 *
 * @returns {list} spacecraftlist - updated list of identified spacecraft
 */
function checkspacecraftstatus(element,spacecraftlist){
    try {
        spacecraftenabled =  ALH.getTagValue(element,"Enable Spacecraft");
        if(String(spacecraftenabled) == "true"){
            spacecraftlist.add(element);
        }
    }
    catch(ERROR) {
    }
    return spacecraftlist;
}

/**
 * @name checkpayloadstatus
 * @description checks if payload is enabled and returns the recurring the list of payloads
 * @param {ALH model element} element - element to be checked for payload status
 * @param {list} payloadlist - list of identified payloads
 *
 * @returns {list} payloadlist - updated list of identified payloads
 */
function checkpayloadstatus(element,payloadlist){
    try {
        payloadenabled =  ALH.getTagValue(element,"Enable Payload");
        if(String(payloadenabled) == "true"){
            payloadlist.add(element);
        }
    }
    catch(ERROR) {
    }
    return payloadlist;
}

/**
 * @name returnpayloads
 * @description returns all payloads belonging to a given spacecraft
 * @param {ALH model element} spacecraft - element to be checked for payloads
 *
 * @returns {list} payloadlist - list of identified payloads
 */
function returnpayloads(spacecraft){

    elementlist = returnSubElements(spacecraft);
    payloadlist = ALH.createList();
    print(elementlist.elementlist[0])
    for (i = 0; i < elementlist.Noelements; i++){
        payloadlist = checkpayloadstatus(elementlist.elementlist[i],payloadlist)
    }
    return payloadlist;
}


//function checkpayloadstatus(element,payloadlist){
//    try {
//        payloadenabled =  ALH.getTagValue(element,"Enable Payload");
//        if(String(payloadenabled) == "true"){
//            payloadlist.add(element);
//    }
//    catch(ERROR) {
//    }
//    return payloadlist;
//}

/**
 * @name checktargetstatus
 * @description checks if target is enabled and returns the recurring the list of targets
 * @param {ALH model element} element - element to be checked for target status
 * @param {list} targetlist - list of identified targets
 *
 * @returns {list} targetlist - updated list of identified targets
 */
function checktargetstatus(element,targetlist){
    try {
        targetenabled =  ALH.getTagValue(element,"Enable Target");
        if(String(targetenabled) == "true"){
            targetlist.add(element);
        }
    }
    catch(ERROR) {
    }
    return targetlist;
}

/**
 * @name checksubtargetstatus
 * @description checks if target is enabled and returns the recurring the list of targets
 * @param {ALH model element} element - element to be checked for target status
 * @param {list} targetlist - list of identified targets
 *
 * @returns {list} targetlist - updated list of identified targets
 */
function checksubtargetstatus(element,subtargetlist){
    try {
        subtargetenabled =  ALH.getTagValue(element,"Enable Target Sub Area");
        if(String(subtargetenabled) == "true"){
            subtargetlist.add(element);
        }
    }
    catch(ERROR) {
    }
    return subtargetlist;
}

/**
 * @name returntargets
 * @description returns all targets belonging to a given payload or spacecraft
 * @param {ALH model element} element - element to be checked for targets
 *
 * @returns {list} targetlist - list of identified targets
 */
function returntargets(element){

    elementlist = returnSubElements(element);
    targetlist = ALH.createList();
    for (i = 0; i < elementlist.Noelements; i++){
        targetlist = checktargetstatus(elementlist.elementlist[i],targetlist)
    }
    return targetlist;
}

/**
 * @name returnsubtargets
 * @description returns all sub targets belonging to a given target
 * @param {ALH model element} element - element to be checked for subtargets
 *
 * @returns {list} subtargetlist - list of identified targets
 */
function returnsubtargets(element){

    elementlist = returnSubElements(element);
    subtargetlist = ALH.createList();
    for (i = 0; i < elementlist.Noelements; i++){
        subtargetlist = checksubtargetstatus(elementlist.elementlist[i],subtargetlist)
    }
    return subtargetlist;
}

/**
 * @name returntargetdatarate
 * @description returns the associated data generation rate for this target/subtarget
 * @param {ALH model element} target - target element to find data rate from
 *
 * @returns {float} datarate - data generation rate fo the target/subtarget
 */
function returntargetdatarate(target){
    try{
        datarate = ALH.getValue(target,"Data Rate");
    }
    catch (ERROR){
        datarate = 0;
    }
    if (datarate == null){
        datarate = 0;
    }

    return datarate;
}

/**
 * @name returntargetfilepath
 * @description returns path of shapefile for area target type target
 * @param {ALH model element} target - element to be checked for target shapefile path
 *
 * @returns {string} path - path to target shapefile
 */
function returntargetfilepath(target){
    try {
        path =  ALH.getTagValue(target,"Shapefile Path");
    }
    catch(ERROR) {
        path = ERROR
    }
    return path;
}
/**
 * @name returntargetfilepath
 * @description returns path of shapefile for area target type target
 * @param {ALH model element} target - element to be checked for target shapefile path
 *
 * @returns {string} path - path to target shapefile
 */
function returnsubtargetfilepath(target){
    try {
        path =  "NONE"
        if ((String(ALH.getTagValue(target, "has Shapefile")) == "true")){
            path =  ALH.getTagValue(target,"Shapefile Path");
        }
    }
    catch(ERROR) {
        path = ERROR
    }
    return path;
}

/**
 * @name convertstringtonumberlist
 * @description old way to sending string to matlab- convert each character to a number and create a list of numbers
 * @param {string} stringtotoconvert - input string to be converted
 *
 * @returns {list} numberlist - list of numbers to send to MATLAB
 */
function convertstringtonumberlist(stringtotoconvert){
    numberlist = [];
    for (counter = 0; counter < stringtotoconvert.length; counter++) {
        character = stringtotoconvert.charAt(counter);

        // mappings to numbers
        // lower case
        if(character ===  "a"){
        number = 1;
        }
        else if(character ===  "b"){
        number = 2;
        }
        else if(character ===  "c"){
        number = 3;
        }
        else if(character ===  "d"){
        number = 4;
        }
        else if(character ===  "e"){
        number = 5;
        }
        else if(character ===  "f"){
        number = 6;
        }
        else if(character ===  "g"){
        number = 7;
        }
        else if(character ===  "h"){
        number = 8;
        }
        else if(character ===  "i"){
        number = 9;
        }
        else if(character ===  "j"){
        number = 10;
        }
        else if(character ===  "k"){
        number = 12;
        }
        else if(character ===  "l"){
        number = 13;
        }
        else if(character ===  "m"){
        number = 14;
        }
        else if(character ===  "n"){
        number = 15;
        }
        else if(character === "o"){
        number = 16;
        }
        else if(character ===  "p"){
        number = 17;
        }
        else if(character ===  "q"){
        number = 18;
        }
        else if(character ===  "r"){
        number = 19;
        }
        else if(character ===  "s"){
        number = 20;
        }
        else if(character ===  "t"){
        number = 21;
        }
        else if(character ===  "u"){
        number = 22;
        }
        else if(character === "v"){
        number = 23;
        }
        else if(character ===  "w"){
        number = 24;
        }
        else if(character ===  "x"){
        number = 25;
        }
        else if(character ===  "y"){
        number = 26;
        }
        else if(character ===  "z"){
        number = 27;
        }
        // upper case
        else if(character ===  "A"){
        number = 28;
        }
        else if(character ===  "B"){
        number = 29;
        }
        else if(character ===  "C"){
        number = 30;
        }
        else if(character ===  "D"){
        number = 31;
        }
        else if(character ===  "E"){
        number = 32;
        }
        else if(character ===  "F"){
        number = 33;
        }
        else if(character ===  "G"){
        number = 34;
        }
        else if(character ===  "H"){
        number = 35;
        }
        else if(character ===  "I"){
        number = 36;
        }
        else if(character ===  "J"){
        number = 37;
        }
        else if(character ===  "K"){
        number = 38;
        }
        else if(character ===  "L"){
        number = 39;
        }
        else if(character ===  "M"){
        number = 40;
        }
        else if(character ===  "N"){
        number = 41;
        }
        else if(character ===  "O"){
        number = 42;
        }
        else if(character ===  "P"){
        number = 43;
        }
        else if(character ===  "Q"){
        number = 44;
        }
        else if(character ===  "R"){
        number = 45;
        }
        else if(character ===  "S"){
        number = 46;
        }
        else if(character ===  "T"){
        number = 47;
        }
        else if(character ===  "U"){
        number = 48;
        }
        else if(character ===  "V"){
        number = 49;
        }
        else if(character ===  "W"){
        number = 50;
        }
        else if(character ===  "X"){
        number = 51;
        }
        else if(character ===  "Y"){
        number = 52;
        }
        else if(character ===  "Z"){
        number = 53;
        }
        // number
        else if(character ===  "0"){
        number = 54;
        }
        else if(character ===  "1"){
        number = 55;
        }
        else if(character ===  "2"){
        number = 56;
        }
        else if(character ===  "3"){
        number = 57;
        }
        else if(character ===  "4"){
        number = 58;
        }
        else if(character ===  "5"){
        number = 59;
        }
        else if(character ===  "6"){
        number = 60;
        }
        else if(character ===  "7"){
        number = 61;
        }
        else if(character ===  "8"){
        number = 62;
        }
        else if(character ===  "9"){
        number = 63;
        }
        // Symbols
        else if(character ===  " "){
        number = 64;
        }
        else if(character ===  "\\" || character ===  "/"){ // take both \ and / to mean /
        number = 65;
        }
        else if(character ===  "-"){
        number = 66;
        }
        else if(character ===  "_"){
        number = 67;
        }
        else if(character ===  ":"){
        number = 68;
        }
        else{
        str1 = "ERROR: string contains unsupported character:";
        message = str1.concat(" index = ",String(character))
        return message;
        }
        numberlist.push(Number(number));
    }
    return numberlist;

}

// data domain functions

/**
 * @name generatedatapacket
 * @description adds data packet to local data buffer element
 * @param {ALH element} localbuffer - local data buffer
 * @param {string} subject - subject fo the data packet -e.g. target name of a observational data packet
 * @param {float} newpacketsize - size of new data packet
 * @param {float} packettimestamp - time stamp at which the data packet was generated
 *
 * @returns {bool} - boolean relating to sucessful or unsucessful data packet creation
 */
function generatedatapacket(localbuffer,subject,newpacketsize,packettimestamp,generationduration){
    destinationspace = getbufferspace(localbuffer);
    packetlist = ALH.getValue(localbuffer,"Sizes");
    timestamplist = ALH.getValue(localbuffer,"Timestamps");
    timestamparrivelist = ALH.getValue(localbuffer,"Time of Arrivals");
    subjectlist = ALH.getValue(localbuffer,"Subjects");
    durationlist = ALH.getValue(localbuffer,"Durations");
    if(destinationspace >= Number(newpacketsize)){
        if (packetlist === null){
            sizelistarray = ALH.createList();
            sizelistarray.add(NaN);
            sizelistarray.add(newpacketsize);
            timestamplistarray = ALH.createList();
            timestamplistarray.add(NaN);
            timestamplistarray.add(packettimestamp);
            timestamparrivelistarray = ALH.createList();
            timestamparrivelistarray.add(NaN);
            timestamparrivelistarray.add(packettimestamp);
            subjectlistarray = ALH.createList();
            subjectlistarray.add("NILL");
            subjectlistarray.add(subject);
            durationlistarray = ALH.createList();
            durationlistarray.add(NaN);
            durationlistarray.add(Number(generationduration));
            ALH.setValue(localbuffer,"Sizes",sizelistarray);
            ALH.setValue(localbuffer,"Timestamps", timestamplistarray);
            ALH.setValue(localbuffer,"Time of Arrivals", timestamparrivelistarray);
            ALH.setValue(localbuffer,"Subjects", subjectlistarray);
            ALH.setValue(localbuffer,"Durations", durationlistarray);
        }
        else {
            packetlist.add(newpacketsize);
            timestamplist.add(packettimestamp);
            timestamparrivelist.add(packettimestamp);
            subjectlist.add(subject);
            durationlist.add(Number(generationduration));
            ALH.setValue(localbuffer,"Sizes",packetlist);
            ALH.setValue(localbuffer,"Timestamps", timestamplist);
            ALH.setValue(localbuffer,"Time of Arrivals", timestamparrivelist);
            ALH.setValue(localbuffer,"Subjects", subjectlist);
            ALH.setValue(localbuffer,"Durations", durationlist);
        }

        return true
    }
    else {
        return false
    }

}

/**
 * @name senddatapacket
 * @description send a designated data packet to a specified destination buffer
 * @param {ALH element} destinationbuffer - destination data buffer
 * @param {ALH element} localbuffer - local data buffer
 * @param {int} destinationbuffer - index of data packet to be sent
 * @param {float} currenttime - current time
 *
 * @returns {float} packetsize - size of sent data packet
 */
function senddatapacket(destinationbuffer,localbuffer,packetindex,currenttime){
    destinationspace = getbufferspace(destinationbuffer);
    packetlist = ALH.getValue(localbuffer,"Sizes")
    // checking number of packets in local buffer
    try{
        testforlist = packetlist.length;
    }
    catch (ERROR) {
        testforlist = null;
    }

    if (testforlist != null){
        packetsize =  ALH.getValue(localbuffer,"Sizes")[packetindex];
        packettimestamp =  ALH.getValue(localbuffer,"Timestamps")[packetindex];
        packetsubject =  ALH.getValue(localbuffer,"Subjects")[packetindex];
        packetduration =  ALH.getValue(localbuffer,"Durations")[packetindex];
    }
    else {
        packetsize =  ALH.getValue(localbuffer,"Sizes");
        packettimestamp =  ALH.getValue(localbuffer,"Timestamps");
        packetsubject =  ALH.getValue(localbuffer,"Subjects");
        packetduration =  ALH.getValue(localbuffer,"Durations");
   }
    // checking number of packets in destination buffer
    destpacketlist = ALH.getValue(destinationbuffer,"Sizes")
    destpackettimestamp =  ALH.getValue(destinationbuffer,"Timestamps");
    desttimeofarrival =  ALH.getValue(destinationbuffer,"Time of Arrivals");
    destsubjects =  ALH.getValue(destinationbuffer,"Subjects")
    destdurations =  ALH.getValue(destinationbuffer,"Durations")

    if(Number(destinationspace) >= Number(packetsize)){
        // when removing data packet list need to ensure there is not a single entry left (i.e. the list is empty or has
        // multiple entries)
        if (packetlist.length == 2){
            ALH.removeValueAt(localbuffer,"Sizes",2); // indexes appear to be counted from 1 when removing values
            ALH.removeValueAt(localbuffer,"Sizes",1);
            ALH.removeValueAt(localbuffer,"Timestamps",2);
            ALH.removeValueAt(localbuffer,"Timestamps",1);
            ALH.removeValueAt(localbuffer,"Time of Arrivals",2);
            ALH.removeValueAt(localbuffer,"Time of Arrivals",1);
            ALH.removeValueAt(localbuffer,"Subjects",2);
            ALH.removeValueAt(localbuffer,"Subjects",1);
            ALH.removeValueAt(localbuffer,"Durations",2);
            ALH.removeValueAt(localbuffer,"Durations",1);
        }
        else{
            ALH.removeValueAt(localbuffer,"Sizes",packetindex+1); // indexes appear to be counted from 1 when removing values and need to account for leading NaN entry
            ALH.removeValueAt(localbuffer,"Timestamps",packetindex+1);
            ALH.removeValueAt(localbuffer,"Time of Arrivals",packetindex+1);
            ALH.removeValueAt(localbuffer,"Subjects",packetindex+1);
            ALH.removeValueAt(localbuffer,"Durations",packetindex+1);
        }

        // now adding data packet to destination buffer
        if (destpacketlist === null){
            sizelistarray = ALH.createList();
            sizelistarray.add(NaN)
            sizelistarray.add(packetsize);
            timestamplistarray = ALH.createList();
            timestamplistarray.add(NaN)
            timestamplistarray.add(packettimestamp);
            timestamparrivelistarray = ALH.createList();
            timestamparrivelistarray.add(NaN)
            timestamparrivelistarray.add(currenttime);
            subjectlistarray = ALH.createList();
            subjectlistarray.add("NILL")
            subjectlistarray.add(packetsubject);
            durationlistarray = ALH.createList();
            durationlistarray.add(NaN);
            durationlistarray.add(packetduration);
            ALH.setValue(destinationbuffer,"Sizes",sizelistarray);
            ALH.setValue(destinationbuffer,"Timestamps", timestamplistarray);
            ALH.setValue(destinationbuffer,"Time of Arrivals", timestamparrivelistarray);
            ALH.setValue(destinationbuffer,"Subjects",subjectlistarray);
            ALH.setValue(destinationbuffer,"Durations",durationlistarray);
        }
        else {
            destpacketlist.add(packetsize);
            destpackettimestamp.add(packettimestamp)
            desttimeofarrival.add(currenttime)
            destsubjects.add(packetsubject)
            destdurations.add(packetduration);
            ALH.setValue(destinationbuffer,"Sizes",destpacketlist);
            ALH.setValue(destinationbuffer,"Timestamps", destpackettimestamp);
            ALH.setValue(destinationbuffer,"Time of Arrivals", desttimeofarrival);
            ALH.setValue(destinationbuffer,"Subjects", destsubjects);
            ALH.setValue(destinationbuffer,"Durations",destdurations);
        }
        return packetsize;
    }
    else {
        return packetsize;
    }

}

/**
 * @name sendpartialdatadatapacket
 * @description send a designated data packet to a specified destination buffer
 * @param {ALH element} destinationbuffer - destination data buffer
 * @param {ALH element} localbuffer - local data buffer
 * @param {int} destinationbuffer - index of data packet to be sent
 * @param {float} currenttime - current time
 *
 * @returns {float} packetsize - size of sent data packet
 */
function sendpartialdatapacket(destinationbuffer,localbuffer,packetindex,partialpacketsize,currenttime){
    destinationspace = getbufferspace(destinationbuffer);
    packetlist = ALH.getValue(localbuffer,"Sizes")
    packetdurationlist = ALH.getValue(localbuffer,"Durations")
    packettimestamplist = ALH.getValue(localbuffer,"Timestamps")
    packetsubjectlist =  ALH.getValue(localbuffer,"Subjects")
    // checking number of packets in local buffer
    try{
        testforlist = packetlist.length;
    }
    catch (ERROR) {
        testforlist = null;
    }

    if (testforlist != null){
        packetsize =  ALH.getValue(localbuffer,"Sizes")[packetindex];
        packettimestamp =  ALH.getValue(localbuffer,"Timestamps")[packetindex];
        packetsubject =  ALH.getValue(localbuffer,"Subjects")[packetindex];
        packetduration =  ALH.getValue(localbuffer,"Durations")[packetindex];
    }
    else {
        packetsize =  ALH.getValue(localbuffer,"Sizes");
        packettimestamp =  ALH.getValue(localbuffer,"Timestamps");
        packetsubject =  ALH.getValue(localbuffer,"Subjects");
        packetduration =  ALH.getValue(localbuffer,"Durations");
    }
    // checking number of packets in destination buffer
    destpacketlist = ALH.getValue(destinationbuffer,"Sizes")
    destpackettimestamp =  ALH.getValue(destinationbuffer,"Timestamps");
    desttimeofarrival =  ALH.getValue(destinationbuffer,"Time of Arrivals");
    destsubjects =  ALH.getValue(destinationbuffer,"Subjects")
    destdurations =  ALH.getValue(destinationbuffer,"Durations")

    if(Number(destinationspace) >= Number(packetsize)){
        // need to ensure the left over downlink capacity is not more than the final packet (don't want negative data sizes)
        if(partialpacketsize < packetsize){
            // change local data packet size to be original minus partial data packet sent
            packetlist[packetindex] = packetsize - partialpacketsize;
            ALH.setValue(localbuffer,"Sizes",packetlist);
            // mark the packet as a partial packet
            packetsubjectlist[packetindex] = packetsubjectlist[packetindex].concat("_Partial_Packet");
            ALH.setValue(localbuffer,"Subjects",packetsubjectlist);
            newpacketsize = partialpacketsize;
            // change the duration to match as well - portion downlinked is proportional to its duration
            packetdurationlist[packetindex] = (1 - partialpacketsize/packetsize) * packetduration;
            ALH.setValue(localbuffer,"Durations",packetdurationlist);
            // also update the timestamp of the packet left behind
            packettimestamplist[packetindex] = packettimestamp + (partialpacketsize/packetsize) * packetduration;
            ALH.setValue(localbuffer,"Timestamps",packettimestamplist);
        }
        else {
            // when removing data packet list need to ensure there is not a single entry left (i.e. the list is empty or has
            // multiple entries)
            if (packetlist.length == 2){
                ALH.removeValueAt(localbuffer,"Sizes",2); // indexes appear to be counted from 1 when removing values
                ALH.removeValueAt(localbuffer,"Sizes",1);
                ALH.removeValueAt(localbuffer,"Timestamps",2);
                ALH.removeValueAt(localbuffer,"Timestamps",1);
                ALH.removeValueAt(localbuffer,"Time of Arrivals",2);
                ALH.removeValueAt(localbuffer,"Time of Arrivals",1);
                ALH.removeValueAt(localbuffer,"Subjects",2);
                ALH.removeValueAt(localbuffer,"Subjects",1);
                ALH.removeValueAt(localbuffer,"Durations",2);
                ALH.removeValueAt(localbuffer,"Durations",1);
            }
            else{
                ALH.removeValueAt(localbuffer,"Sizes",packetindex+1); // indexes appear to be counted from 1 when removing values and need to account for leading NaN entry
                ALH.removeValueAt(localbuffer,"Timestamps",packetindex+1);
                ALH.removeValueAt(localbuffer,"Time of Arrivals",packetindex+1);
                ALH.removeValueAt(localbuffer,"Subjects",packetindex+1);
                ALH.removeValueAt(localbuffer,"Durations",packetindex+1);
            }
            newpacketsize = packetsize;
        }

        // now adding data packet to destination buffer
        if (destpacketlist === null){
            sizelistarray = ALH.createList();
            sizelistarray.add(NaN)
            sizelistarray.add(newpacketsize);
            timestamplistarray = ALH.createList();
            timestamplistarray.add(NaN)
            timestamplistarray.add(packettimestamp);
            timestamparrivelistarray = ALH.createList();
            timestamparrivelistarray.add(NaN)
            timestamparrivelistarray.add(currenttime);
            subjectlistarray = ALH.createList();
            subjectlistarray.add("NILL")
            subjectlistarray.add(packetsubject.concat('_Partial_Packet')); // label the packet as a partial packet
            durationlistarray = ALH.createList();
            durationlistarray.add(NaN);
            durationlistarray.add((partialpacketsize/packetsize) * packetduration);
            ALH.setValue(destinationbuffer,"Sizes",sizelistarray);
            ALH.setValue(destinationbuffer,"Timestamps", timestamplistarray);
            ALH.setValue(destinationbuffer,"Time of Arrivals", timestamparrivelistarray);
            ALH.setValue(destinationbuffer,"Subjects",subjectlistarray);
            ALH.setValue(destinationbuffer,"Durations",durationlistarray);
        }
        else {
            destpacketlist.add(newpacketsize);
            destpackettimestamp.add(packettimestamp)
            desttimeofarrival.add(currenttime)
            destsubjects.add(packetsubject.concat('_Partial_Packet')) // label the packet as a partial packet
            destdurations.add((partialpacketsize/packetsize) * packetduration);
            ALH.setValue(destinationbuffer,"Sizes",destpacketlist);
            ALH.setValue(destinationbuffer,"Timestamps", destpackettimestamp);
            ALH.setValue(destinationbuffer,"Time of Arrivals", desttimeofarrival);
            ALH.setValue(destinationbuffer,"Subjects", destsubjects);
            ALH.setValue(destinationbuffer,"Durations",destdurations);
        }
        return packetsize;
    }
    else {
        return packetsize;
    }

}

/**
 * @name getbufferspace
 * @description returns a specified data buffer free space
 * @param {ALH element} buffer - buffer to return free space of
 *
 * @returns {float} space - free space left on buffer
 */
function getbufferspace(buffer){
    totalsize = ALH.getValue(buffer,"Buffer Size");
    packetlist = ALH.getValue(buffer,"Sizes");
    occupiedspace = 0;
    try{
        noentries = packetlist.length;
    }
    catch (ERROR) {
        noentries = 0;
    }
    for (counter = 0; counter < noentries; counter++){
        if(isNaN(packetlist[counter])){
            thepacketsize = 0;
        }
        else {
            thepacketsize = Number(packetlist[counter]);
        }
        occupiedspace = occupiedspace + thepacketsize;
    }
    space = totalsize - occupiedspace;
    return space
}

/**
 * @name getUsedBufferSpace
 * @description returns a specified data buffer used space
 * @param {ALH element} buffer - buffer to return used space of
 *
 * @returns {float} occupiedspace - space used on buffer
 */
function getUsedBufferSpace(buffer){
    packetlist = ALH.getValue(buffer,"Sizes");
    occupiedspace = 0;
    try{
        noentries = packetlist.length;
    }
    catch (ERROR) {
        noentries = 0;
    }

    for (counter = 0; counter < noentries; counter++){
        if(isNaN(packetlist[counter])){
            thepacketsize = 0;
        }
        else {
            thepacketsize = Number(packetlist[counter]);
        }
        occupiedspace = occupiedspace + thepacketsize;
    }
    return Number(occupiedspace);
}

/**
 * @name identifyPacketstoDownlink
 * @description returns data packets that maybe downlinked in a given comms pass
 * @param {float} datrate - rate of data downlink
 * @param {float} duration - duration of comms pass
 * @param {ALH element} buffer - buffer to stream from
 *
 * @returns {object} - volume of data downlinked, downlink time, partial packet data and final downlink packet index
 */
function identifyPacketstoDownlink(datrate,duration,buffer){
    maxdatatdownlink = datrate * duration;
    packetlist = ALH.getValue(buffer,"Sizes");
    try{
        noentries = packetlist.length;
    }
    catch (ERROR) {
        noentries = 0;
        downlinkeddata = 0;
        downlinktime = 0;
        finalpacketdownlinked = 0;
        partialpacket =maxdatatdownlink;
    }
    countedspace = 0;
    for (counter = 0; counter < noentries; counter++){
        if(isNaN(packetlist[counter])){
            thepacketsize = 0;
        }
        else {
            thepacketsize = Number(packetlist[counter]);
        }
        countedspace = countedspace + thepacketsize;
        if (countedspace > maxdatatdownlink){
            downlinkeddata = countedspace - thepacketsize;
            downlinktime = downlinkeddata / datrate;
            finalpacketdownlinked = counter - 1;
            break
        }
        else {
            downlinkeddata = countedspace;
            downlinktime = downlinkeddata / datrate;
            finalpacketdownlinked = counter;
            partialpacket = maxdatatdownlink - downlinkeddata;
        }
    }
    return {
        'datavolume': downlinkeddata,
        'time': downlinktime,
        'finalpacketdownlinked': finalpacketdownlinked,
        'partialpacket': partialpacket
      };
}
function getElementBuffer(element){
    buffer =  ALH.getValue(element,"Buffer")
    return buffer
}

/**
 * @name updatedataprofile
 * @description updates MATLAB struct tracking the current element's data buffer
 * @param {ALH element} element - current active element
 * @param {float} currenttime - current time
 */
function updatedataprofile(element,updatetime){
    // the data profile is stored in a global variable
    // firstly finding expected name of global variable
    variablenameelement = getObjectName(element);

    // now returning buffer used space
    bufferupdate = getElementBuffer(element);
    bufferoccupiedspaceupdate = getUsedBufferSpace(bufferupdate);
    // most recent packet time of arrival
    try{
        check = ALH.getValue(bufferupdate,"Time of Arrivals").length;
        timeofarrivals = ALH.getValue(bufferupdate,"Time of Arrivals");
        timeofcreations = ALH.getValue(bufferupdate,"Timestamps");
        subjects = ALH.getValue(bufferupdate,"Subjects");
        durations = ALH.getValue(bufferupdate,"Durations");
    }
    catch (ERROR){
        timeofarrivals = NaN;
        timeofcreations = NaN;
        subjects = 'NILL';
        durations = NaN;
    }
    // need to handle cases where the cell array for data profiles does and does not already exist
    expressionstring = "exist('DataProfilesStruct');";
    exist = ALH.evaluate("MATLAB",expressionstring);
    if (exist==false){
        expressionstring = "DataProfilesStruct = struct;";
        exist = ALH.evaluate("MATLAB",expressionstring);
    } 

    expressionstring = "isfield(DataProfilesStruct,'";
    expressionstring = expressionstring.concat(variablenameelement,"');");
    exist = ALH.evaluate("MATLAB",expressionstring);
    if (exist){
        // record buffer occupied space
        expressionstring = "DataProfilesStruct."
        expressionstring = expressionstring.concat(variablenameelement);
        expressionstring = expressionstring.concat(".DATA(end+1)=",String(bufferoccupiedspaceupdate),";");
        ALH.evaluate("MATLAB",expressionstring);
        // record current timestamp
        expressionstring = "DataProfilesStruct.";
        expressionstring = expressionstring.concat(variablenameelement);
        expressionstring = expressionstring.concat(".TIME(end+1)=",String(updatetime),";");
        ALH.evaluate("MATLAB",expressionstring);
        // record data packet time of arrivals
        expressionstring = "DataProfilesStruct.";
        expressionstring = expressionstring.concat(variablenameelement);
        expressionstring = expressionstring.concat(".TIMEOFARRIVALS{end+1}=",String(timeofarrivals),";");
        ALH.evaluate("MATLAB",expressionstring);
        // record data packet timestamps
        expressionstring = "DataProfilesStruct.";
        expressionstring = expressionstring.concat(variablenameelement);
        expressionstring = expressionstring.concat(".TIMESTAMPS{end+1}=",String(timeofcreations),";");
        ALH.evaluate("MATLAB",expressionstring);
        // record recent data packet subject
        expressionstring = "DataProfilesStruct.";
        expressionstring = expressionstring.concat(variablenameelement);
        expressionstring = expressionstring.concat(".SUBJECT{end+1}='",String(subjects),"';");
        ALH.evaluate("MATLAB",expressionstring);
        // record recent data packet subject
        expressionstring = "DataProfilesStruct.";
        expressionstring = expressionstring.concat(variablenameelement);
        expressionstring = expressionstring.concat(".DURATIONS{end+1}='",String(durations),"';");
        ALH.evaluate("MATLAB",expressionstring);
    }
    else {
        expressionstring = "DataProfilesStruct.";
        expressionstring = expressionstring.concat(variablenameelement);
        expressionstring = expressionstring.concat(".DATA=",String(bufferoccupiedspaceupdate),";");
        ALH.evaluate("MATLAB",expressionstring);
        expressionstring = "DataProfilesStruct.";
        expressionstring = expressionstring.concat(variablenameelement);
        expressionstring = expressionstring.concat(".TIME=",String(updatetime),";");
        ALH.evaluate("MATLAB",expressionstring);
        expressionstring = "DataProfilesStruct.";
        expressionstring = expressionstring.concat(variablenameelement);
        expressionstring = expressionstring.concat(".TIMEOFARRIVALS{1}=",String(timeofarrivals),";");
        ALH.evaluate("MATLAB",expressionstring);
        expressionstring = "DataProfilesStruct.";
        expressionstring = expressionstring.concat(variablenameelement);
        expressionstring = expressionstring.concat(".TIMESTAMPS{1}=",String(timeofcreations),";");
        ALH.evaluate("MATLAB",expressionstring);
        expressionstring = "DataProfilesStruct.";
        expressionstring = expressionstring.concat(variablenameelement);
        expressionstring = expressionstring.concat(".SUBJECT{1}='",String(subjects),"';");
        ALH.evaluate("MATLAB",expressionstring);
        expressionstring = "DataProfilesStruct.";
        expressionstring = expressionstring.concat(variablenameelement);
        expressionstring = expressionstring.concat(".DURATIONS{1}='",String(durations),"';");
        ALH.evaluate("MATLAB",expressionstring);
    }
}

/**
 * @name getRecentPacketTimeOfArrival
 * @description returns the most recent packet time of arrival to the buffer
 * @param {ALH element} buffer - buffer
 *
 * @returns {float} - most recent packets time of arrival
 */
function getRecentPacketTimeOfArrival(buffer){
    finalentry = ALH.getValue(buffer,"Time of Arrivals").length;
    return ALH.getValue(buffer,"Time of Arrivals")[finalentry];
}

/**
 * @name getRecentPacketTimestamp
 * @description returns the most recent packet timestamp
 * @param {ALH element} buffer - buffer
 *
 * @returns {float} - most recent packets timestamp
 */
function getRecentPacketTimestamp(buffer){
    finalentry = ALH.getValue(buffer,"Timestamps").length;
    return ALH.getValue(buffer,"Timestamps")[finalentry];
}

/**
 * @name getElementCurrentPower
 * @description returns the element's elements current power
 * @param {ALH element} element - element to return current power of
 *
 * @returns {float} elementCurrentPower - element current power
 */
function getElementCurrentPower(element){
    elementCurrentPower = ALH.getValue(element,"Current Power")
    return elementCurrentPower;
}

/**
 * @name updatepowerprofile
 * @description updates MATLAB struct tracking the current element's power
 * @param {ALH element} element - current active element
 * @param {float} currenttime - current time
 */
function updatepowerprofile(element,currenttime){
    // the data profile is stored in a global variable
    // firstly finding expected name of global variable
    variablenameelement = getObjectName(element);
    currentelementpower = getElementCurrentPower(element);
    // need to handle cases where the cell array for data profiles does and does not already exist
    expressionstring = "exist('PowerProfilesStruct');"
    exist = ALH.evaluate("MATLAB",expressionstring)
    if (exist==false){
        expressionstring = "PowerProfilesStruct = struct;"
        exist = ALH.evaluate("MATLAB",expressionstring)
    }

    expressionstring = "isfield(PowerProfilesStruct,'"
    expressionstring = expressionstring.concat(variablenameelement,"');");
    exist = ALH.evaluate("MATLAB",expressionstring)
    if (exist){
        expressionstring = "PowerProfilesStruct."
        expressionstring = expressionstring.concat(variablenameelement);
        expressionstring = expressionstring.concat(".POWER(end+1)=",String(currentelementpower),";");
        ALH.evaluate("MATLAB",expressionstring)
        expressionstring = "PowerProfilesStruct."
        expressionstring = expressionstring.concat(variablenameelement);
        expressionstring = expressionstring.concat(".TIME(end+1)=",String(currenttime),";");
        ALH.evaluate("MATLAB",expressionstring)
    }
    else {
        expressionstring = "PowerProfilesStruct."
        expressionstring = expressionstring.concat(variablenameelement);
        expressionstring = expressionstring.concat(".POWER=",String(currentelementpower),";");
        ALH.evaluate("MATLAB",expressionstring)
        expressionstring = "PowerProfilesStruct."
        expressionstring = expressionstring.concat(variablenameelement);
        expressionstring = expressionstring.concat(".TIME=",String(currenttime),";");
        ALH.evaluate("MATLAB",expressionstring)
    }
}

// CONOPS functions

/**
 * @name getObjectName
 * @description returns the element's name as a sting
 * @param {ALH element} element - element to name of
 *
 * @returns {string} objectname - element name
 */
function getObjectName(object){
    objectstr = String(object);
    fullsplit = objectstr.split('@');
    objectname = fullsplit[0];
    return objectname
}

/**
 * @name getObjectName
 * @description checks if element's name is particular string
 * @param {ALH element} element - element to name of
 * @param {string} name - string to check name against
 *
 * @returns {bool} - outcome of test
 */
function checkObjectName(element,name){
    elementname = getObjectName(element)
    if (elementname === name){
        return true
    }
    else {
        return false
    }
}

/**
 * @name getNamedModelElement
 * @description searches the model structure of a element with ehe specified name
 * @param {string} Modelname - string to check name against
 *
 * @returns {ALH model element} - matched element
 */
function getNamedModelElement(Modelname){
    // searching model element tree for named element
    Element = ContextHelper.findSessionRootObject($context$.getRefSession());

    // setup loop variables
    elementcount = 0;
    linkchoice = 0;
    risingflag = false;
    elementpath = ALH.createList();
    elementpathcheckedelements = ALH.createList();
    elementpathcheckedelements.add(0);
    elementpathlist = ALH.createList();
    nodiscoveredsubelementsunchecked = 1;
    dislist = ALH.createList();
    dislist.add(nodiscoveredsubelementsunchecked)
    noelementslist = ALH.createList();
    visitedelements = ALH.createList();
    linkchoicelist = ALH.createList();
    loops = 0;
    deadends = 0;
    functiontime = null;

    try{
    while(nodiscoveredsubelementsunchecked>0 && loops <= 1000){
        // firlsty check if current root element is the fucntion
        if (risingflag == false){
            elementfound = checkObjectName(Element,Modelname);
            if (elementfound == true){
                elementresult = Element;
            }
        }

        // return subelements of current element
        linkchoicelist.add(linkchoice)
        subelementset = returnSubElements(Element);
        nocheckedsudelements = elementpathcheckedelements[elementcount];
        noelementslist.add(subelementset.Noelements);
        visitedelements.add(String(Element));


        // if new element, update number of discovered but uncheck elements accordingly
        if(nocheckedsudelements == 0){
            nodiscoveredsubelementsunchecked = nodiscoveredsubelementsunchecked -1 + subelementset.Noelements;
            linkchoice = 0;
            dislist.add(nodiscoveredsubelementsunchecked)
        }
        else if(subelementset.Noelements > nocheckedsudelements && risingflag == false){
            nodiscoveredsubelementsunchecked = nodiscoveredsubelementsunchecked -1;
            dislist.add(nodiscoveredsubelementsunchecked)
        }
        // new elements to be explored
        if (subelementset.Noelements > nocheckedsudelements){
            // update Element to next element to be explored
            elementpath.add(Element);
            elementpathcheckedelements[elementcount] = elementpathcheckedelements[elementcount] + 1;
            elementpathcheckedelements.add(0);
            elementcount = elementcount + 1;
            Element = subelementset.elementlist[linkchoice];
            linkchoice = 0
            risingflag = false;
        // no new elements to be explored
        }else{
            // reverse one link up tree
            Element = elementpath[elementcount-1];
            linkchoice = elementpathcheckedelements[elementcount-1];
            elementpathlist.add(elementpath);
            elementpath.remove(elementcount-1);
            elementpathcheckedelements.remove(elementcount);
            linkchoicelist.remove(linkchoicelist.size()-1);
            linkchoicelist.remove(linkchoicelist.size()-1);
            elementcount = elementcount - 1;
            deadends = deadends + 1
            risingflag = true;
        }
        loops = loops + 1;
        }
        ERROR = "completed element tree";
        }
        catch (ERR) {
            ERROR = String(ERR);

        }

    // finally return the element with matching name
    return elementresult;
}

/**
 * @name resetElementState
 * @description returns an element to a specified state (must have a defined transition)
 * @param {ALH model element} element - element to change state
 * @param {string} initialstate - signal name to reset element with
 */
function resetElementState(element,initialstate){
    resetsignal = ALH. createSignal(initialstate)
    ALH.sendSignal(resetsignal,element)
}

/**
 * @name recordElementPropValues
 * @description returns the propety values belonging to a given model element
 * @param {ALH model element} element - element to record propeties of
 * @param {list} elementaddr - element address
 * @param {list} subproplist - list of identified element propeties
 *
 * @returns {list} - updated list of identified element propeties
 */
function recordElementPropValues(element,elementaddr,subproplist){
    subprops = returnSubPropeties(element)
    for (i = 0; i <subprops.Noprops; i++){
        if (String(subprops.proplist[i]).search('@') ==-1){
            value = ALH.getValue(element,String(subprops.proplist[i]));
            subproplist.Values.add(value);
            subproplist.Adresses.add(String(elementaddr));
            subproplist.Propname.add(String(subprops.proplist[i]));
        }
    }
    return {
        'Values': subproplist.Values,
        'Adresses': subproplist.Adresses,
        'Propname': subproplist.Propname
      };
}

/**
 * @name resetElementPropValues
 * @description resets elements propeties values to original recorded values
 * @param {ALH model element} element - element to record propeties of
 * @param {list} elementaddr - element address
 * @param {list} subproplist - list of identified element propeties
 *
 * @returns {list} - updated list of identified element propeties
 */
function resetElementPropValues(element,elementaddr,subproplist){
    // special case for clearing buffers
    if (getObjectName(element) == "Buffer"){
        resetElementBuffer(element);
    }
    else {
    // resetting general property values
    subprops = returnSubPropeties(element)
    for (i = 0; i <subprops.Noprops; i++){
        initialvalue = retrievePropValueFromStruct(elementaddr,String(subprops.proplist[i]));
        try{
            ALH.setValue(element,String(subprops.proplist[i]),initialvalue);
        }
        catch(ERROR){
        }
        subproplist.updatecounter++;
    }
    }
    return {
        'Values': subproplist.Values,
        'Adresses': subproplist.Adresses,
        'Propname': subproplist.Propname,
        'updatecounter': subproplist.updatecounter
    }
}

/**
 * @name resetElementPropValues
 * @description resets elements propeties values to original recorded values
 * @param {ALH model element} element - element to record propeties of
 * @param {list} elementaddr - element address
 * @param {list} subproplist - list of identified element propeties
 *
 * @returns {list} - updated list of identified element propeties
 */
function resetElementPropValuesFromInstance(element){
    try{
         // special case for clearing buffers
        if (getObjectName(element) == "Buffer"){
            resetElementBuffer(element);
        }
        else {
            elementclassifier = element.getTypes()[0]; // first get classifier
            elementinstance = elementclassifier.get_instanceSpecificationOfClassifier()[0]; // get instance spec related to classifier
            // creat list of defining element names to compare propety names to
            defelementnamelist= ALH.createList();
            for(i = 0; i <elementinstance.getSlot().length; i++){
                defelementnamelist.add(elementinstance.getSlot()[i].getDefiningFeature().name)
            }

            subprops = returnSubPropeties(element);
            for (i = 0; i <subprops.Noprops; i++){
                for (j = 0; j <defelementnamelist.length; j++){
                    if (String(subprops.proplist[i]) ===  String(defelementnamelist[j]))
                        try{
                            initialvalue = ValueSpecificationHelper.getValueSpecificationValue(elementinstance.getSlot()[j].getValue()[0]);
                            ALH.setValue(element,String(subprops.proplist[i]),initialvalue);
                        }
                        catch(ERROR){
                        }
                     }
            }
        }
    }
    catch (ERROR){
    }
}


/**
 * @name retrievePropValueFromStruct
 * @description reuturns given recorded property value from MATLAB
 * @param {list} elementaddr - element address
 * @param {string} propname - name of property to retrieve form MATLAB
 *
 * @returns {float} initialvalue - recorded initial property value
 */
function retrievePropValueFromStruct(elementaddr,propname){
    expressionstring = "currentelementprops = find(contains(CameoInitialPropeties.Elementaddress,'"
    expressionstring = expressionstring.concat(String(elementaddr),"'))");
    currentelementprops = ALH.evaluate("MATLAB",expressionstring);
    // handle case where current element has no propeties
    expressionstring = "size(currentelementprops,2)"
    sizecheck = ALH.evaluate("MATLAB",expressionstring);
    if (sizecheck != 0){
        expressionstring = "currentprop = min(currentelementprops)-1+find(contains(CameoInitialPropeties.Name(min(currentelementprops):max(currentelementprops)),'"
        expressionstring = expressionstring.concat(propname,"'))");
        ALH.evaluate("MATLAB",expressionstring);
        expressionstring = "currentpropfinal = currentprop(1)"
        ALH.evaluate("MATLAB",expressionstring);
        expressionstring = "CameoInitialPropeties.Value(currentpropfinal)"
        retrievedvalue = ALH.evaluate("MATLAB",expressionstring);
    }
    else{
        retrievedvalue == "NULL"
    }
    // handling null values
    if (retrievedvalue == "NULL"){
        initialvalue = null
    }
    else{
        initialvalue = retrievedvalue
    }

    return initialvalue
}

/**
 * @name resetElementBuffer
 * @description resets given data buffer
 * @param {ALH model element} buffer - buffer to reset
 */
function resetElementBuffer(buffer){
    ALH.setValue(buffer,"Sizes",null);
    ALH.setValue(buffer,"Timestamps",null);
    ALH.setValue(buffer,"Time of Arrivals",null);
    ALH.setValue(buffer,"Subjects",null);

}

/**
 * @name updateSTKAnimationTime
 * @description updates the STK animation time
 */
function updateSTKAnimationTime(){
    allowAnimationUpdate = false;
    if (allowAnimationUpdate){
        mbsemachine = ContextHelper.findSessionRootObject($context$.getRefSession());
        updatedmissiontime = ALH.getValue(mbsemachine,"Mission Time");

        expressionstring = "Animationtime = "
        expressionstring = expressionstring.concat('datestr(datetime(',String(updatedmissiontime),",'ConvertFrom','posixtime'),","'dd mmm yyyy HH:MM:SS.FFF');");
        ALH.evaluate("MATLAB",expressionstring);


        expressionstring = "root.ExecuteCommand(sprintf('SetAnimation * CurrentTime "
        expressionstring = expressionstring.concat('"%s"',"',",'Animationtime));');
        ALH.evaluate("MATLAB",expressionstring);
    }


}

