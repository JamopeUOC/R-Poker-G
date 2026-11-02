
/// @desc removes a value from an array. If the value is present in the array multiple times, only 1 of them will be deleted;
/// @param {array} array the array to remove the value from
/// @param {any} value the value to remove from the array
function array_remove(array, value){
    var index = array_get_index(array,value);
    if(index != -1){
        array_delete(array,index,1);
    }
}