### 索引管理

* 创建索引

  ```json
  PUT study
  {
    "settings": {
      "number_of_shards": 3,
      "number_of_replicas": 1
    } 
  }
  
  //返回
  {
    "acknowledged" : true,
    "shards_acknowledged" : true,
    "index" : "study"
  }
  
  ```

* 查看索引

  ```json
  GET study/_settings
  #查看多个索引GET /learn,study/_settings
  //返回
  {
    "study" : {
      "settings" : {
        "index" : {
          "creation_date" : "1565667302748",
          "number_of_shards" : "3",
          "number_of_replicas" : "1",
          "uuid" : "Woqg14etSdCohWmDHeHUnA",
          "version" : {
            "created" : "6080099"
          },
          "provided_name" : "study"
        }
      }
    }
  }
  ```

* 删除索引

  ```json
  DELETE test
  # 返回
  {
    "acknowledged": true
  }
  
  ```

* 索引的打开与关闭

  ```json
  #关闭索引
  POST /learn/_close
  
  #重新打开索引
  POST /learn/_open
  ```

### 映射mapping

映射(Mapping)相当于数据表的表结构。ES中的映射（Mapping）用来定义一个文档，可以定义所包含的字段以及字段的类型、分词器及属性等等。ElasticSearch中不需要事先定义映射（Mapping），文档写入ElasticSearch时，会根据文档字段自动识别类型，这种机制称之为动态映射,反之就是静态映射了。动态映射的自动类型推测功能并不是100%正确的，这就需要静态映射机制。

```json
# 查看
GET /book/_mapping
//返回
{
  "book": {
    "mappings": {}
  }
}

```

新建映射

```json
PUT books
{
  "mappings":{
    "it": {
       "properties": {
          "bookId": {"type": "long"},
          "bookName": {"type": "text"},
          "publishDate": {"type": "date"}
       }
    }
  }
}

//返回
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "books"
}
//反查mapping
GET books/_mapping
//返回
{
  "books" : {
    "mappings" : {
      "it" : {
        "properties" : {
          "bookId" : {
            "type" : "long"
          },
          "bookName" : {
            "type" : "text"
          },
          "publishDate" : {
            "type" : "date"
          }
        }
      }
    }
  }
}
```

#### 字段类型

* 字符串类型

  * string 类型在ElasticSearch 旧版本中使用较多，从ElasticSearch 5.x开始不再支持string，由text和keyword类型替代。
  * text 当一个字段是要被全文搜索的，比如Email内容、产品描述，应该使用text类型。设置text类型以后，字段内容会被分析，在生成倒排索引以前，字符串会被分析器分成一个一个词项。text类型的字段**不用于排序，很少用于聚合**。
  * keyword 类型适用于索引结构化的字段，比如email地址、主机名、状态码和标签。如果字段需要进行过滤(比如查找已发布博客中status属性为published的文章)、排序、聚合。**keyword****类型的字段只能通过精确值搜索到**

* 数值类型

  * byte -128~127
  * short -32768~32767
  * integer -2^31~2^31-1
  * long -2^63~2^63-1
  * double
  * float 
  * half_float
  * scaled_float

* Date类型

  ElasticSearch 内部会将日期数据转换为UTC，并存储为milliseconds-since-the-epoch的long型整数。

  创建mapping的时候可以采用类似的方式进行格式设置。

  ```json
  PUT test
  {
    "mappings":{
      "my":{
        "properties": {
          "postdate":{
            "type":"date",
            "format": "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_millis"
          }
        }
      }
    }
  }
  
  # 写入文档
  PUT test/my/1
  {
    "postdate":"2018-01-13"
    //"postdate":"2018-01-01 00:01:05"
    //"postdate":"1420077400001"
  }
  ```

* boolean类型

  逻辑类型（布尔类型）可以接受true/false/”true”/”false”值

* **binary类型**

  二进制字段是指用base64来表示索引中存储的二进制数据，可用来存储二进制形式的数据，例如图像。默认情况下，该类型的字段只存储不索引。二进制类型只支持index_name属性

* **array类型**

  在ElasticSearch中，没有专门的数组（Array）数据类型，但是，在默认情况下，任意一个字段都可以包含0或多个值，这意味着每个字段默认都是数组类型。在同一个数组中，数组元素的数据类型是相同的，ElasticSearch不支持元素为多个数据类型：[ 10, “some string”]

* Object类型

  JSON天生具有层级关系，文档会包含嵌套的对象

* IP类型

  ip类型的字段用于存储IPv4或者IPv6的地址

### 文档

6.x之后不允许添加多个type

#### 新增文档

```json
PUT study/blog/1
{
  "id":1,
  "title":"Elasticsearch简介",
  "author":"kyle",
  "content":"Elasticsearch是一个基于Lucene的搜索引擎"
}
//返回
{
  "_index" : "study",
  "_type" : "blog",
  "_id" : "1",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 0,
  "_primary_term" : 1
}

## 未指定文档ID
POST study/blog
{
  "id":3,
  "title":"Elasticsearch简介1",
  "author":"kyle1",
  "content":"Elasticsearch是一个基于Lucene的搜索引擎"
}
//返回
{
  "_index" : "study",
  "_type" : "blog",
  "_id" : "vZoiiWwBWQWPkkfk1k9n",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 0,
  "_primary_term" : 1
}

```

#### 更新文档

文档在Elasticsearch中是不可变的，不能修改。如果我们需要修改文档，Elasticsearch实际上重建新文档替换掉旧文档

```json
# 更新文档id为2的文档
POST /blog/segmentfault/2
{
  "id":2,
  "title":"Git简介",
  "author":"hahaha",
  "content":"Git是一个分布式版本控制软件"
}
//返回
{
  "_index": "blog",
  "_type": "segmentfault",
  "_id": "2",
  "_version": 2,
  "result": "updated",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  },
  "_seq_no": 1,
  "_primary_term": 1
}

## 字段更新
POST /blog/segmentfault/2/_update
{
  "script": {
    "source": "ctx._source.content=\"GIT是一个开源的分布式版本控制软件\""  
  }
}
{
  "_index": "blog",
  "_type": "segmentfault",
  "_id": "2",
  "_version": 3,
  "result": "updated",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  },
  "_seq_no": 2,
  "_primary_term": 1
}
## 查询更新
POST blog/_update_by_query
{
  "script": {
    "source": "ctx._source.category=params.category",
    "lang":"painless",
    "params":{"category":"git"}
  },
  "query":{
    "term": {"title":"git"}
  }
}

```

#### 删除文档

```json
DELETE /blog/segmentfault/2
//返回
{
  "_index": "blog",
  "_type": "segmentfault",
  "_id": "2",
  "_version": 7,
  "result": "deleted",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  },
  "_seq_no": 6,
  "_primary_term": 1
}

```

####   文档搜索

* 最简单的空查询

  ```json
  GET boss/_search
  //返回
  {
    "took" : 10,//告诉我们执行整个搜索请求耗费了多少毫秒
    "timed_out" : false,//是否超时
    "_shards" : {//查询中参与分片的总数，以及这些分片成功了多少个失败了多少个
      "total" : 5,
      "successful" : 5,
      "skipped" : 0,
      "failed" : 0
    },
     
    "hits" : {//查询结果中最重要的部分
      "total" : 240090,//查询总共匹配到记录数
      "max_score" : 1.0,
      "hits" : [//一般会返回匹配的前十条记录
        {...},
        {...},
        {...},
        {...},
        {...},
        {...},
        {...},
        {...},
        {...},
        {...}
          }
        }
      ]
    }
  }
  ```

* 分页查询

  Elasticsearch 接受 from 和 size 参数。显示应该跳过的初始结果数量，默认是 0

  ```
  GET /_search?size=5&from=5
  或者在查询语句中设置
  GET /_search
  {
   "from":0,
   "size":2
  }
  ```

###  查询表达式

本节应该属于上大节的最后一个小结，但是因为其重要性因此单独起一节。ES提供了一种非常灵活又富有表现力的查询语言，采用JSON接口的方式实现丰富的查询，并使你的查询语句更灵活、更精确、更易读且易调试，这种方式被称为Query DSL语言。其查用如下的格式就进行查询，可以指定from和size进行分页查询

```json
GET /_search
{
    "query": YOUR_QUERY_HERE
}
```

* match_all 即无检索条件获取全部数据

  ```json
  # 查询全部数据
  GET /boss/_search
  {
      "query": {
        "match_all": {}
      }
  }
  ```

* query_string 查询 可以执行一些复杂的查询

  ```json
  GET /boss/_search
  {
      "query" : {
          "query_string": {
              //查询inter=QHAI_UNHQ_BalanceInfoQuery 或者reqinfo.SERIAL_NUMBER = 151的记录
            "query": "inter:QHAI_UNHQ_BalanceInfoQuery or reqinfo.SERIAL_NUMBER:151"
          }
      }
  }
  ```

  

* match 普通检索，很多文章都说`match`查询会对查询内容进行分词，其实并不完全正确，`match`查询也要看检索的字段`type`类型，如果字段类型本身就是不分词的`keyword`(`not_analyzed`)，那`match`就等同于`term`查询了

  ```json
  GET /boss/_search
  {
      "query": {
          "match": {
              "title": "我们会被分词"
          }
      }
  }
  ```

* multi_match对多个字段进行检索，比如我想查询`title`或`content`中有`我们`关键词的文档

  ```json
  GET /boss/_search
  {
      "query": {
        "multi_match": {
          "query": "15110990584",
          "fields": ["reqinfo.SERIAL_NUMBER","reqinfo.SERIAL_NUMBER.keyword"]
        }
      }
  }
  ```

* match_phrase/match_phrase_prefix 短查询 slop为几就是允许间隔几个词，几个词之间离的越近分数越高

  ```json
  GET /boss/_search
  {
      "query": {
        "match_phrase_prefix" : {
              "reqinfo.SERIAL_NUMBER": {
                  "query" : "151109905",
                  "max_expansions" : 10
              }
          }
      },
      "size": 50
  }
  ```

* term查找被用于精确值 匹配，这些精确值可能是数字、时间、布尔或者那些 `not_analyzed` 的字符串。

  ```json
  GET /boss/_search
  {
      "query": {
        "term": {
          "reqinfo.SERIAL_NUMBER": {
            "value": "15110990584"
          }
        }
      }
  }
  ```

* terms 查询和 `term`查询一样，但它允许你指定多值进行匹配。如果这个字段包含了指定值中的任何一个值，那么这个文档满足条件。terms 查询对于输入的文本不分析。它查询那些精确匹配的值（包括在大小写、重音、空格等方面的差异）

  ```json
  GET /boss/_search
  {
      "query": {
        "terms": {
          "reqinfo.SERIAL_NUMBER": [
            "151xxxxxxxx",
            "152xxxxxxxx"
          ]
        }
        
      }
  }
  ```

* range范围查找，如果对字符串进行比较，那么是数字<大写字母<小写字母，字符从头开始比较，和js一样range的主要参数为：　　

  　　　　　　`gt`: `>` 大于（greater than）

  　　　　　　`lt`: `<` 小于（less than）

  　　　　　　`gte`: `>=` 大于或等于（greater than or equal to）

  　　　　　　`lte`: `<=` 小于或等于（less than or equal to）

  ```json
  GET /boss/_search
  {
      "query" : {
          "range": {
            "requesttime": {
              "gt":"20190103101058526",
              "lt":"20190103101158526"
            }
          }
      }
  }
  ```

* wildcard `shell`通配符查询: `?` 一个字符 `*` 多个字符，查询`倒排索引`中符合`pattern`的关键词

  ```json
  GET /my_index/address/_search
  {
      "query": {
          "wildcard": {
              "postcode": "W?F*HW" 
          }
      }
  }
  ```

  

* prefix 前缀查询

* regexp 正则查询

  ```json
  GET /my_index/address/_search
  {
      "query": {
          "regexp": {
              "postcode": "W[0-9].+" 
          }
      }
  }
  ```

  

* bool 布尔连接查询must必须全部满足、must_not 必须全部不满足、should满足一个即可

  ```json
  GET /boss/_search
  {
      "query" : {
          "bool": {
            "filter": [{
              "term": {
                "reqinfo.SERIAL_NUMBER": "15110990584"
              }
            },{
                "term": {
                "reqinfo.ACCT_TYPE_CODE": "0"
              }
            }],
            "must": [
              {"term": {
                "response.respCode": "0"
              }}
            ]
          }
      }
  }
  ```

  

* filter查询 通常情况下会配合`match`之类的使用，对符合查询条件的数据进行过滤。

  

* exists和missing查询，分别用来判断是否存在或者缺失

* constant_score查询：它被经常用于你只需要执行一个 filter 而没有其它查询（例如，评分查询）的情况下。可以使用它来取代只有 filter 语句的 `bool` 查询。在性能上是完全相同的，但对于提高查询简洁性和清晰度有很大帮助。　

* 设置最小匹配度　　后面可以是数字也可以是百分比

  ```json
  GET /my_index/my_type/_search
  {
    "query": {
      "match": {
        "title": {
          "query":                "quick brown dog",
          "minimum_should_match": "75%"
        }
      }
    }
  }
  ```

* 使用临近度提高相关度

  ```json
  GET /my_index/my_type/_search
  {
    "query": {
      "bool": {
        "must": {
          "match": { 
            "title": {
              "query":                "quick brown fox",
              "minimum_should_match": "30%"
            }
          }
        },
        "should": {
          "match_phrase": { 
            "title": {
              "query": "quick brown fox",
              "slop":  50
            }
          }
        }
      }
    }
  }
  ```

  

