支付宝扫福背后的可能涉及的一个问题，就是五福已经花花卡怎么得到。这里面涉及到很多的游戏规则，当然问题的本质就是从一个数组中按照一定的比例获取一项元素。
随机获取一个指定数组的元素和按照一定比例获取随机项这种功能在一定的在日常开发中肯定很常见。前者相对实现起来比较简单，但是后者网上有千奇百怪的而实现方式，而且其代码俩都相对较大，领人阅读的时候不能很愉快。当然每个人都有每个人的实现方式，凡是自己实现确实是不错的选择，至少是对自己的一种锻炼。今天我就给出我的一种实现方式相对其他方式极大的简化了原理和实现方式。另外其实按照现有的常见系统这里面处理涉看似简单的游戏规则外，还有很多的AI和大数据成品，影响着随机的结果。具体代码见[github](https://github.com/0opslab/opslabJutil)



# 随机项
## 实现方式
```java
    /**
     * 生成制定范围内的随机数
     *
     * @param scopeMin
     * @param scoeMax
     * @return
     */
    public static int integer(int scopeMin, int scoeMax) {
        Random random = new Random();
        return (random.nextInt(scoeMax) % (scoeMax - scopeMin + 1) + scopeMin);
    }
    /**
     * 从指定的数组中随机数组中的某个元素
     */
    public static <T> T randomItem(T[] param) {
        int index = integer(0, param.length);
        return param[index];
    }
```
## 测试
```java
    @Test
    public void testRandomItem(){
        for (int j = 0; j < 10; j++) {
            Map<Integer,Integer> map = new HashMap();
            for (int i = 0; i < 1000000; i++) {
                Integer integer = RandomUtil.randomItem(new Integer[]{10, 30, 50});
                if(map.containsKey(integer)){
                    map.put(integer,map.get(integer)+1);
                }else{
                    map.put(integer,1);
                }
            }
            int count = map.get(10)+map.get(30)+map.get(50);
            String str = "10/30/50 ="+map.get(10)+":"+map.get(30)+":"+map.get(50)
                    +"("+count+")";
            System.out.println(str);
        }
    }
```
### 测试结果
此处我随机了1000000次，下面是一些测试结果，从结果上来看相对还是比较靠谱
```java
10/30/50 =333651:332493:333856(1000000)
10/30/50 =333098:333090:333812(1000000)
10/30/50 =333791:332406:333803(1000000)
10/30/50 =333052:333188:333760(1000000)
10/30/50 =333131:333132:333737(1000000)
10/30/50 =333920:333441:332639(1000000)
10/30/50 =332876:333978:333146(1000000)
10/30/50 =333948:332682:333370(1000000)
10/30/50 =333180:333794:333026(1000000)
10/30/50 =333030:333798:333172(1000000)
```

# 按照比例随机项
相对网络上的其他方式，此方法的实现原理很简单就随机一个数字，通过这个数字反映出其位置，然后通过位置即可保证随机比例，测试的时候发现随机的次数越多比例越接近设定的值。
## 实现
```java
     /**
     * 从指定的数组中按照指定比例返回指定的随机元素
     *
     * @param param 随机数组
     * @param percentum 比例
     * @param <T>
     * @return
     */
    public static <T> T randomItem(T[] param, double[] percentum) {
        int length = percentum.length;
        Integer[] ints = ArrayUtil.doubleBitCount(percentum);
        int max = Collections.max(Arrays.asList(ints));
        int[] arr = new int[length];
        int sum = 0;
        Map map = new HashMap(length);
        StringBuffer buffer = new StringBuffer();
        for (int i = 0; i < max; i++) {
            buffer.append("0");
        }
        int multiple = Integer.parseInt("1" + buffer.toString());
        for (int i = 0; i < length; i++) {
            int temp = (int) (percentum[i] * multiple);
            arr[i] = temp;
            if (i == 0) {
                map.put(i, new int[]{1, temp});
            } else {
                map.put(i, new int[]{sum, sum + temp});
            }
            sum += temp;
        }
        int indexSum = integer(1, sum);
        int index = -1;
        for (int i = 0; i < length; i++) {
            int[] scope = (int[]) map.get(i);
            if (indexSum == 1) {
                index = 0;
                break;
            }
            if (indexSum > scope[0] && indexSum <= scope[1]) {
                index = i;
                break;
            }
        }
        if (index == -1) {
            throw new RuntimeException("随机失败");
        } else {
            return param[index];
        }
    }
```
## 测试
```java
        @Test
    public void testRandomItemRatio(){

        for (int j = 0; j < 10; j++) {
            Map<Integer,Integer> map = new HashMap();
            for (int i = 0; i < 1000000; i++) {
                double[] percentum = new double[]{0.6,0.3,0.1};
                Integer integer = RandomUtil.randomItem(new Integer[]{10, 30, 50}, percentum);
                if(map.containsKey(integer)){
                    map.put(integer,map.get(integer)+1);
                }else{
                    map.put(integer,1);
                }
            }
            int count = map.get(10)+map.get(30)+map.get(50);
            String str = "10/30/50 ="+map.get(10)+":"+map.get(30)+":"+map.get(50)
                    +"("+count+") ->"+
                    StringHelper.formatNumber(new BigDecimal(map.get(10)/(float)count),"#.0000")+":"+
                    StringHelper.formatNumber(new BigDecimal(map.get(30)/(float)count),"#.0000")+":"+
                    StringHelper.formatNumber(new BigDecimal(map.get(50)/(float)count),"#.0000");
            System.out.println(str);
        }

        //
        System.out.println("测试万分之一的概率");
        for (int j = 0; j < 10; j++) {
            Map<Integer,Integer> map2 = new HashMap();
            for (int i = 0; i < 1000000; i++) {
                double[] percentum = new double[]{0.6,0.4999,0.0001};
                Integer integer = RandomUtil.randomItem(new Integer[]{10, 30, 50}, percentum);
                if(map2.containsKey(integer)){
                    map2.put(integer,map2.get(integer)+1);
                }else{
                    map2.put(integer,1);
                }
            }
            int count = map2.get(10)+map2.get(30)+map2.get(50);
            String str = "10/30/50 ="+map2.get(10)+":"+map2.get(30)+":"+map2.get(50)
                    +"("+count+") ->"+
                    StringHelper.formatNumber(new BigDecimal(map2.get(10)/(float)count),"#.00000")+":"+
                    StringHelper.formatNumber(new BigDecimal(map2.get(30)/(float)count),"#.00000")+":"+
                    StringHelper.formatNumber(new BigDecimal(map2.get(50)/(float)count),"#.00000");
            System.out.println(str);
        }
        System.out.println("测试十万分之一的概率");
        for (int j = 0; j < 10; j++) {
            Map<Integer,Integer> map3 = new HashMap();
            for (int i = 0; i < 1000000; i++) {
                double[] percentum = new double[]{0.6,0.49999,0.00001};
                Integer integer = RandomUtil.randomItem(new Integer[]{10, 30, 50}, percentum);
                if(map3.containsKey(integer)){
                    map3.put(integer,map3.get(integer)+1);
                }else{
                    map3.put(integer,1);
                }
            }
            int count = map3.get(10)+map3.get(30)+map3.get(50);
            String str = "10/30/50 ="+map3.get(10)+":"+map3.get(30)+":"+map3.get(50)
                    +"("+count+") ->"+
                    StringHelper.formatNumber(new BigDecimal(map3.get(10)/(float)count),"#.000000")+":"+
                    StringHelper.formatNumber(new BigDecimal(map3.get(30)/(float)count),"#.000000")+":"+
                    StringHelper.formatNumber(new BigDecimal(map3.get(50)/(float)count),"#.000000");
            System.out.println(str);
        }
    }
```
## 测试结果
```java
10/30/50 =600354:299397:100249(1000000) ->0.6004:0.2994:0.1002
10/30/50 =600025:299830:100145(1000000) ->0.6000:0.2998:0.1001
10/30/50 =600126:299818:100056(1000000) ->0.6001:0.2998:0.1001
10/30/50 =600687:299354:99959(1000000) ->0.6007:0.2994:0.1000
10/30/50 =600916:299568:99516(1000000) ->0.6009:0.2996:0.0995
10/30/50 =599388:300589:100023(1000000) ->0.5994:0.3006:0.1000
10/30/50 =599777:299881:100342(1000000) ->0.5998:0.2999:0.1003
10/30/50 =599734:300583:99683(1000000) ->0.5997:0.3006:0.0997
10/30/50 =599214:300557:100229(1000000) ->0.5992:0.3006:0.1002
10/30/50 =600500:299443:100057(1000000) ->0.6005:0.2994:0.1001
测试万分之一的概率
10/30/50 =545096:454801:103(1000000) ->0.54510:0.45480:0.00010
10/30/50 =545798:454116:86(1000000) ->0.54580:0.45412:0.00009
10/30/50 =545413:454495:92(1000000) ->0.54541:0.45450:0.00009
10/30/50 =545842:454068:90(1000000) ->0.54584:0.45407:0.00009
10/30/50 =544981:454932:87(1000000) ->0.54498:0.45493:0.00009
10/30/50 =545930:453973:97(1000000) ->0.54593:0.45397:0.00010
10/30/50 =545555:454358:87(1000000) ->0.54555:0.45436:0.00009
10/30/50 =546784:453122:94(1000000) ->0.54678:0.45312:0.00009
10/30/50 =545536:454370:94(1000000) ->0.54554:0.45437:0.00009
10/30/50 =545724:454168:108(1000000) ->0.54572:0.45417:0.00011
测试十万分之一的概率
10/30/50 =545508:454484:8(1000000) ->0.545508:0.454484:0.000008
10/30/50 =545711:454281:8(1000000) ->0.545711:0.454281:0.000008
10/30/50 =545483:454506:11(1000000) ->0.545483:0.454506:0.000011
10/30/50 =545286:454706:8(1000000) ->0.545286:0.454706:0.000008
10/30/50 =545381:454612:7(1000000) ->0.545381:0.454612:0.000007
10/30/50 =545623:454368:9(1000000) ->0.545623:0.454368:0.000009
10/30/50 =546073:453914:13(1000000) ->0.546073:0.453914:0.000013
10/30/50 =545580:454403:17(1000000) ->0.545580:0.454403:0.000017
10/30/50 =545413:454582:5(1000000) ->0.545413:0.454582:0.000005
10/30/50 =545211:454781:8(1000000) ->0.545211:0.454781:0.000008
```