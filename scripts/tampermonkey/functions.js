/**
 * 以开头
 */
String.prototype.startsWith = function (s) {
  if (s == null || s == "" || this.length == 0 || s.length > this.length)
    return false;
  if (this.substr(0, s.length) == s)
    return true;
  else
    return false;
  return true;
}

/**
 * 以结尾
 * @param {*} s 
 */
String.prototype.endsWith = function (s) {
  if (s == null || s == "" || this.length == 0 || s.length > this.length)
    return false;
  if (this.substring(this.length - s.length) == s)
    return true;
  else
    return false;
  return true;
}
