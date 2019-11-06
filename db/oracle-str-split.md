在 PLSQL编程的时候经常需要用到对字符串的操作，例如拆分和分割等。但Oracle中没有可以可用的方法因此需要自己实现。

## 分割
    ```sql
    create or replace function Get_StrArrayLength(
      av_str varchar2,  --要分割的字符串
      av_split varchar2  --分隔符号
    )
    return number
    is
      lv_str varchar2(1000);
      lv_length number;
    begin
      lv_str:=ltrim(rtrim(av_str));
      lv_length:=0;
      while instr(lv_str,av_split)<>0 loop
         lv_length:=lv_length+1;
         lv_str:=substr(lv_str,instr(lv_str,av_split)+length(av_split),length(lv_str));
      end loop;
      lv_length:=lv_length+1;
      return lv_length;
    end Get_StrArrayLength;
    ```

## 提取
    ```sql
    create or replace function Get_StrArrayStrOfIndex
    (
      av_str varchar2,  --要分割的字符串
      av_split varchar2,  --分隔符号
      av_index number --取第几个元素
    )
    return varchar2
    is
      lv_str varchar2(1024);
      lv_strOfIndex varchar2(1024);
      lv_length number;
    begin
      lv_str:=ltrim(rtrim(av_str));
      lv_str:=concat(lv_str,av_split);
      lv_length:=av_index;
      if lv_length=0 then
          lv_strOfIndex:=substr(lv_str,1,instr(lv_str,av_split)-length(av_split));
      else
          lv_length:=av_index+1;
            lv_strOfIndex:=substr(lv_str,instr(lv_str,av_split,1,av_index)+length(av_split),
            instr(lv_str,av_split,1,lv_length)-instr(lv_str,av_split,1,av_index)-length(av_split));
      end if;
      return  lv_strOfIndex;
    end Get_StrArrayStrOfIndex;
    ```
## 测试
   ```sql
    select Get_StrArrayStrOfIndex('songguojun$@111111537','$',0) from dual
   ```

# 第二种

本函数可以将“目标字符串”以“指定字符串”进行拆分，并通过表结构返回结果。代码如下：

    ```sql
    CREATE OR REPLACE TYPE str_split IS TABLE OF VARCHAR2 (4000);
    CREATE OR REPLACE FUNCTION splitstr(p_string IN VARCHAR2, p_delimiter IN VARCHAR2)
        RETURN str_split
        PIPELINED
    AS
        v_length   NUMBER := LENGTH(p_string);
        v_start    NUMBER := 1;
        v_index    NUMBER;
    BEGIN
        WHILE(v_start <= v_length)
        LOOP
            v_index := INSTR(p_string, p_delimiter, v_start);

            IF v_index = 0
            THEN
                PIPE ROW(SUBSTR(p_string, v_start));
                v_start := v_length + 1;
            ELSE
                PIPE ROW(SUBSTR(p_string, v_start, v_index - v_start));
                v_start := v_index + 1;
            END IF;
        END LOOP;

        RETURN;
    END splitstr;
```
创建完毕后，我们来测试一下，例如执行如下SQL：
```sql
    select * from table(splitstr('Hello,Cnblogs!',','));
```


# 将行转为列显示
```sql
    select a.column_value v1,b.column_value v2 from
    (select * from (select rownum rn,t.* from table(splitstr('Hello,Cnblogs!',',')) t)) a,
    (select * from (select rownum rn,t.* from table(splitstr('Hello,Cnblogs!',',')) t)) b
    where a.rn=1 and b.rn=2
```