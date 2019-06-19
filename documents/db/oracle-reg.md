---
title: Oracle 中使用正则表达式
date: 2017-10-16 20:06:51
tags:
    - sql
    - oracle
categories: Oracle
---
Oracle使用正则表达式离不开这4个函数：regexp_like、regexp_substr、regexp_instr、regexp_replace。
# regexp_like
该函数只能用于条件表达式，和 like 类似，但是使用的正则表达式进行匹配
```sql
//查询所有包含小写字母或者数字的记录。
 select * from fzq where regexp_like(value,'^([a-z]+|[0-9]+)$');
```
# regexp_substr
该函数和 substr 类似，用于拾取合符正则表达式描述的字符子串,该函数的定义如下
```sql
function REGEXP_SUBSTR(String, pattern, position, occurrence, modifier)
    - String 输入的字符串
    - pattern 正则表达式
    - position 标识从第几个字符开始正则表达式匹配。（默认为1）
    - occurrence  标识第几个匹配组。（默认为1）
    - modifier 取值范围：
        i：大小写不敏感；
        c：大小写敏感；
        n：点号 . 不匹配换行符号；
        m：多行模式；
        x：扩展模式，忽略正则表达式中的空白字符。
```
下面是一些实例
```sql
--检索中间的数字
SELECT  REGEXP_SUBSTR(a,'[0-9]+')  FROM  test_reg_substr  WHERE  REGEXP_LIKE(a, '[0-9]+');

--检索中间的数字（从第一个字母开始匹配，找第2个匹配项目）
SELECT  NVL(REGEXP_SUBSTR(a,'[0-9]+',1, 2), '-') AS a  FROM  test_reg_substr  
WHERE  REGEXP_LIKE(a, '[0-9]+');
```
# regexp_instr
该函数和 instr 类似，用于标定符合正则表达式的字符子串的开始位置，Oracle数据库中的REGEXP_INSTR函数的语法是
```sql
REGEXP_INSTR (source_char, pattern [, position [, occurrence 
        [, return_option [, match_parameter ] ] ]  ] )
    - source_char 搜索值的字符表达式
    - pattern  正则表达式
    - position 可选。搜索在字符串中的开始位置。如果省略，则默认为1，这是字符串中的第一个位置。
    - occurrence 可选。它是模式字符串中的第n个匹配位置。如果省略，默认为1。 
    - return_option 可选 指定Oracle返回的位置,
            0那么Oracle将返回出现的第一个字符的位置。这是默认的,
            1则Oracle返回字符之后发生的位置。
    - match_parameter 取值范围：
            i：大小写不敏感；
            c：大小写敏感；
            n：点号 . 不匹配换行符号；
            m：多行模式；
            x：扩展模式，忽略正则表达式中的空白字符。
```
下面是一些实例
```sql
--找到字符串中的第一个”e”字的位置
--返回2
SELECT REGEXP_INSTR ('hello itmyhome', 'e') FROM dual; 

--“1”为开始位置 “2”是搜索第二个匹配的，”0”是return_option 
--返回出现的第一个字符位置“c”是区分大小写 ，所以将返回13
SELECT REGEXP_INSTR ('my is itMyhome', 'm', 1, 2, 0, 'c') FROM dual;
--
SELECT REGEXP_INSTR ('World filled with love', 'with', 1, 1, 0, 'i') FROM dual;

--匹配多个备选
SELECT REGEXP_INSTR ('Itmyhome', 'a|i|o|e|u') FROM dual;
```
# regexp_replace
该函数和 replace 类似，用于替换符合正则表达式的字符串,Oracle数据库中的REGEXP_REPLACE函数的语法是
```sql
REGEXP_REPLACE(source_char, pattern [, replace_string 
        [, position [, occurrence [, match_parameter ] ] ] ])
    - source_char  搜索值的字符表达式
    - pattern 正则表达式
    - replace_string 可选。匹配的模式将被替换replace_string字符串。
        如果省略replace_string参数，将删除所有匹配的模式，并返回结果字符串。
    - position 可选。在字符串中的开始位置搜索。如果省略，则默认为1。
    - occurrence 它是模式字符串中的第n个匹配位置。如果省略，默认为1。
    - match_parameter
        i：大小写不敏感；
        c：大小写敏感；
        n：点号 . 不匹配换行符号；
        m：多行模式；
        x：扩展模式，忽略正则表达式中的空白字符。
```
如下是一些实例
```sql
--字符串替换
--luck is my network id
SELECT REGEXP_REPLACE ('itmyhome is my network id', '^(\S*)', 'luck') FROM dual;


--此示例将所指定的\d数字将以#字符替换
--Result: '#, #, and ## are numbers in this example'
SELECT REGEXP_REPLACE ('2, 5, and 10 are numbers in this example', '\d', '#') FROM dual;
```