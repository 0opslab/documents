
## Go���Ա���淶
Go�������ϸ����ִ�Сд
GoӦ�ó����ִ�������main����

####  Go�ĺ������������������Զ������͡�����������ʽ��ѭ���¹���
```
1�����ַ������������Unicode�ַ������»���
2��ʣ���ַ�������Unicode�ַ����»��ߡ�����
3) �ַ����Ȳ���
4) golang�и�������ĸ�Ĵ�Сд��ȷ�����Է��ʵ�Ȩ�ޡ������Ƿ����������������������ǽṹ������ƣ�
    �������ĸ��д������Ա������İ����ʣ��������ĸСд����ֻ���ڱ�����ʹ�ÿ��Լ򵥵����ɣ�
    ����ĸ��д�ǹ��еģ�����ĸСд��˽�е�
5) �ṹ�����������Ĵ�д
```

#### Goֻ��25���ؼ���
break default func interface select
case defer go map struct
chan else goto package switch
const fallthrough if range type
continue for import return var


## Go���Ի���
### ����������ʼ��
���������Թؼ��� var ��ͷ�����ñ������ͣ���β����ֺţ�GO���Եı���������ʽΪ:
var ������  ��������
```go
// ����һ���������͵ı��������Ա���������ֵ
var a int
// ����һ���ַ������͵ı���
var b string
// ����һ�� 32 λ������Ƭ���͵ı���
var c []float32
// ����һ������ֵΪ�������͵ĺ�������
var d func() bool
//����һ���ṹ�����͵ı���
var e struct{
	    x int
	}
//������ʽ
var (
    a int
    b string
    c []float32
    d func() bool
    e struct {
        x int
    }
)
```
*������ʼ��*�ı�׼��ʽ
var ������ ���� = ���ʽ
```go
//����һ��int����ֵ100�ı���
var hp int = 100
//�ڱ�׼��ʽ�Ļ����ϣ��� int ʡ�Ժ󣬱������᳢�Ը��ݵȺ��ұߵı��ʽ�Ƶ� hp ����������
var hp = 100

//������͵ı������岢��ʼ��
hp := 100
//��������������ֵ��һ�������Ӷ���һ���� err ����
conn, err := net.Dial("tcp","127.0.0.1:8080")

// ���ظ�ֵ a��b��ֵ����
b, a = a, b


```

��ʹ�ö��ظ�ֵʱ���������Ҫ����ֵ�н��ձ���������ʹ������������anonymous variable����
���������ı�����һ���»���_��ʹ����������ʱ��ֻ��Ҫ�ڱ��������ĵط�ʹ���»����滻����
```go
func GetData() (int, int) {
    return 100, 200
}
a, _ := GetData()
_, b := GetData()
```

### ����
Go ֧���ַ����ַ�������������ֵ ���� ��const ��������һ��������
```go
const s string = "constant"
```
### ���̿���
 Go �����Ǵ� main() ������ʼִ�У�Ȼ��˳��ִ�иú������еĴ���
 * if-else �ṹ
 * switch �ṹ
 * select �ṹ
 * for (range) �ṹ
������һЩ����
```go
func main() {
    var first int = 10
    var cond int

    if first <= 0 {
        fmt.Printf("first is less than or equal to 0\n")
    } else if first > 0 && first < 5 {

        fmt.Printf("first is between 0 and 5\n")
    } else {

        fmt.Printf("first is 5 or greater\n")
    }
   
   var num1 int = 100
   
   switch num1 {
       case 98, 99:
           fmt.Println("It's equal to 98")
       case 100: 
           fmt.Println("It's equal to 100")
       default:
           fmt.Println("It's not equal to 98 or 100")
       }
   
   //һ�� break �����÷�ΧΪ�������ֺ�����ڲ��Ľṹ��
   // �����Ա������κ���ʽ�� for ѭ�����������������жϵȣ���
   // ���� switch �� select ����У�
   // break �������ý����������������飬ִ�к����Ĵ��롣
   
   //�ؼ��� continue ����ʣ���ѭ�����ֱ�ӽ�����һ��ѭ���Ĺ��̣�
   // ������������ִ����һ��ѭ����ִ��֮ǰ������Ҫ����ѭ�����ж�����
   for i:=0; i<5; i++ {
       for j:=0; j<10; j++ {
           println(j)
       }
   }
   
   
   //for��switch �� select ��䶼������ϱ�ǩ��label����ʽ�ı�ʶ��ʹ�ã�
   // ��ĳһ�е�һ����ð�ţ�:����β�ĵ��ʣ�gofmt �Ὣ���������Զ�������һ�У���
   LABEL1:
       for i := 0; i <= 5; i++ {
           for j := 0; j <= 5; j++ {
               if j == 4 {
                   continue LABEL1
               }
               fmt.Printf("i is: %d, and j is: %d\n", i, j)
           }
       }
}
```
### ָ��
��GO������ָ��Pointer�����Ϊ�������ĸ���
* ����ָ�룬��������ָ�����͵����ݽ����޸ģ���������ʹ��ָ�룬���������ݿ���������ָ�벻�ܽ���ƫ�ƺ�����
* ��Ƭ����ָ���ʼԪ�ص�ԭʼָ�롢Ԫ��������������ɡ�

ÿ������������ʱ��ӵ����һ����ַ�������ַ����������ڴ��е�λ�ã�Go������ʹ��&�������ڱ���ǩ���Ա������С�ȡ��ַ��������
```go
// ����v����ȡ��ַ�ı�������ȡ��ַ��vʹ��ptr�������н��գ�ptr������Ϊ*T ������T��ִ�����͡�*����ָ������
ptr := &v



var cat int = 1
var str string = "banana"
fmt.Printf("%p %p", &cat, &str)
//ָ��ֵ����0x��ʮ������ǰ׺
���:0xc042052088 0xc0420461b0
```

### ����
�����д������:
```go
var ��������� [Ԫ������]T
func main() {
    var arr1 [5]int

    for i:=0; i < len(arr1); i++ {
        arr1[i] = i * 2
    }

    for i:=0; i < len(arr1); i++ {
        fmt.Printf("Array at index %d is %d\n", i, arr1[i])
    }
}
```

### ��Ƭslice
��Ƭ��Go��һ���ؼ����������ͣ���һ�����������ǿ������кŽӿڡ�������Python��Java�е�list����ʵ�ʿ�����ʹ�õ��൱�Ķࡣ
```go
//�������еĸ�ʽ������Ҫ˵�����ȣ�
var name []type
//����make��������һ����Ƭ
var slice1 []type = make([]type,len)
//����д��
sclie2 := make([]type,len)
```
ʵ��
```go
func main(){
	//����һ����Ƭ
	s := make([]string,3)
	fmt.Println("emp:",s)
	
	//��ֵ
	s[0] ="a"
	s[1] ="b"
	s[2] ="c"
	
	//����
	fmt.Println("set:",s)
	fmt.Println("get:",s[1])
	fmt.Println("len:",len(s))
	
	//��̬׷��Ԫ��
	s = append(s,"d")
	s = append(s,"e","f")
	fmt.Println("set:",s)
	
	
	//��Ƭ����
	c := make([]string,len(s))
	copy(c,s)
	fmt.Println("copy",c)
	
	//��Ƭ����Ƭ�﷨
	//Slice ֧��ͨ�� slice[low:high] �﷨���С���Ƭ�����������磬����õ�һ������Ԫ�� s[2], s[3],s[4] �� slice��
    //��� slice �� s[0] �������ǰ�����s[5]
    
    l := s[2:5]
    fmt.Println("newSclie:",l)
	
}
```
����Ƭ���ݸ�����
```go
func sum(a []int) int{
	s := 0
	for i :=0;i<len(a);i++{
		s += a[i]
	}
	return s
}
func main() {
    var arr = [5]int{0, 1, 2, 3, 4}
    sum(arr[:])
}

```

### ��������map
������Ƭ���Ϊmap���ճ�������Ҳ�������õ������������й�����ϵ�����ݵ�ʱ��
map���������ͣ������������µ�������ʽ
```go
var map1 map[keytype]valuetype
//����д��
map2 := make(map[string]int)
```
ʵ��
```go
func main(){
	//����һ��map���͵ı���
	m := make(map[string]int)
	
	
	//����������ֵ
	m["k1"] = 1
	m["k2"] = 2
	
	//��ȡֵ
	fmt.Println(m["k1"])
	
	//ɾ��ֵdelete����Ϊ�ڽ�����
	delete(m["k2"])
	
	//��һ�ֳ�ʼ������
	n := map[string]int{"ss":1,"ba":2}
	
}
```

### Range����
��Go����һ��ʹ��range���Ե������ָ��������ݽṹ��
```go
func main(){
	nums := []int[2,3,4]
	for k,v := range nums{
		fmt.Println("arr ",k," =>",v)
	}
	
	kvs := map[string]string{"a": "apple", "b": "banana"}
    for k, v := range kvs {
        fmt.Printf("%s -> %s\n", k, v)
    }
}
```

### ����
�����ǻ����Ĵ���顣Go�Ǳ����͵����ԣ����к�����д��˳�����޹ؽ�Ҫ�ģ�һ��Ѻ���������ǰ�棬
�����Ķ����ʽ���£�
```go
//����main()��init()�����⣬�����������͵ĺ����������в����뷵��ֵ��
// ��������������ֵ�Լ����ǵ����ͱ�ͳ��Ϊ����ǩ��

//������������ĸ�����֡��»�����ɡ����У��������ĵ�һ����ĸ����Ϊ���֡���ͬһ�����ڣ��������Ʋ���������
//�����б�һ�������ɲ��������Ͳ����������
//���ز����б������Ƿ���ֵ�����б�Ҳ���������Ʋ����б��б�����������������ϡ�
//      �����������з���ֵʱ�������ں�������ʹ�� return ����ṩ����ֵ�б�
//��������
//      ����ֵ�����б� = ������(�����б�)
func ������(�����б�)(���ز����б�){
    ������
}
```
��Go�������������͵ĺ���
* ��ͨ�Ĵ������ֵĺ���
* ������������lambda����
* ������Methods��

ʵ��
```go
/**
 * ����һ������
 */
func plus(a int,b int){
	return a + b
}

/**
 * ����һ������,���ض��ֵ
 */
func vals()(int,int){
	return 0,1
}

/**
 * ����һ������,���տɱ����
 */
func min(a ...int) int{
	if len(a)==0 {
            return 0
    }
    min := a[0]
    for _, v := range a {
        if v < min {
            min = v
        }
    }
    return min
}


func main(){
	res := plus(1,2)
	fmt.Println("1+2=",res)
	
	//���÷��ض��ֵ�ĺ���
	a,b := vals()
	
	//�ɱ������������
	minvalue := min(1,2,0,3,4)
	fmt.Prinlnt(minvalue)
	
}
```
##### ��������
���������Ķ����ʽ����:
```go
func (�����б�)(���ز����б�){
	������
}
//���������ڶ���ʱ�Ϳ��Ե���
func(data string){
	fmt.Println("hello ",data)
}("Test")

//�������������Ƹ�����
f := func(data string){
	fmt.Println("hello ",data)
}
//ʹ�ñ�������
f("Test")


//ʹ���������������ص�����
func visit(list []int,f func(int)){
	for _,v  := list{
		f(v)
	}
}

//ʹ������������ӡ��Ƭ����
visit([]int{1,2,3,4,5},func(v int){
	fmt.Println(v)
})

```

##### init����
ÿһ��Դ�ļ���������һ��init�������ú�������main����ǰ��go�ĵ����������á�
�ú���һ������������һЩ��ʼ��������

##### �հ�
�հ�����һ��������������صĻ���(������)һͬ��ϳ���һ���������
�հ��ǿ��԰������ɣ�δ�󶨵��ض����󣩱����Ĵ���飬��Щ�����������������ڻ���
�κ�ȫ���������ж��壬�����ڶ�������Ļ����ж��塣Ҫִ�еĴ���飨�������ɱ�������
�ڴ�����У�������Щ���ɱ����Լ��������õĶ���û�б��ͷţ�Ϊ���ɱ����ṩ�󶨵ļ��㻷
���������򣩡��հ��ļ�ֵ���ڿ�����Ϊ�����������������������������ϵͳ���ԣ�����ζ�Ų���Ҫ��ʾ
���ݻ�Ҫ��ʾ���롣֧�ֱհ��Ķ������Զ���������Ϊ��һ�����󣬾���˵��Щ�������Դ洢��
��������Ϊ�������ݸ���������������Ҫ�����ܹ���������̬�����ͷ��ء�
```go
// ����һ������makeSuffix����һ������Ϊfunc(string) string�ĺ���
func makeSuffix(suffix string) func(string) string {
    return func(name string) string {
        if strings.HasSuffix(name, suffix) == false {
            return name + suffix
        }
        return name
    }
}

func main() {
    //�ж��ַ��� ��bmp��β
    f1 := makeSuffix(".bmp")
    fmt.Println(f1("test"))
    fmt.Println(f1("pic"))
    f2 := makeSuffix(".jpg")
    fmt.Println(f2("test"))
    fmt.Println(f2("pic"))
}
```


##### defer�ӳ�ִ��
�ؼ��� defer ���������Ƴٵ���������֮ǰ��������λ��ִ�� return ���֮��һ�̲�ִ��ĳ��
��������ΪʲôҪ�ڷ���֮���ִ����Щ��䣿��Ϊ return ���ͬ�����԰���һЩ����������
�ǵ����ط���ĳ��ֵ�����ؼ��� defer ���÷�������������������� Java �� C# �� finally
���飬��һ�������ͷ�ĳЩ�ѷ������Դ
```go
func main() {
	prose_list = make([]string, 0)
	f, err := os.Open("c:/data.json")
	if err != nil {
		panic(err)
	}
	defer f.Close()
	rd := bufio.NewReader(f)
	for {
		line, err := rd.ReadString('\n')
		if err != nil || io.EOF == err {
			break
		}
		fmt.Println(line)
	}
}
```
### defer panic recover
Go����׷�������ţ�����Go���Բ�֧�ִ�ͳ��try...catch..finally���ִ���Go������Ĵ���ʽΪdefer��panic��recover
ʹ��panic���쳣��Ȼ����defer��ͨ��recover��������쳣��Ȼ����������
```go
func test(){
	defer func(){
		//ʹ��defer+recover������ʹ����쳣
		err := recover()
		if err != nil{
			fmt.Println("err=",err)
		}
	}()
	
	num1 := 10
	num2 := 0
	res := num1 /num2
	fmt.Println("res=",res)
}
```
### �ṹ��
�ṹ���Ǳ����ļ��ϣ���������֯��ʱ�������൱������á�
�������涨����һ���ṹ��
```go
type Person struct{
	name string
	age  int
}
```
�ṹ���ʹ�úͳ���ı���ʹ�û���һ��
```go
func main(){
	fmt.Println(Person{"Bob",20})
	fmt.Println(Person{name:"Bob",age:20})
	fmt.Println(Person{name:"Bob"})
	
	//ָ������
	ps := &Person{name:"Test",age��20}
	fmt.Println(ps.name)
	fmt.Println(ps.age)
	
	sp.name="Test1"
	sp.age=22
	fmt.Println(ps.name)
	fmt.Println(ps.age)
	
	//ʹ��new��������ִ�нṹ���ָ��
	t := new(Person)
	t.name ="test2"
	t.age = 20
	fmt.Println(t.name)
	fmt.Println(t.age)
	
	
	
}
```
Ϊ�ṹ����ӷ���
��Go�����з���(Method)��һ���������ض����ͱ����ĺ����������ض����ͱ���������������Receiver��
������ض��������Ϊ�ṹ�����ʱ���������ĸ���������������������е�this��self��������
```go
//����������
//���������ͣ����������ͺͲ������ƣ�������ָ�����ͺͷ�ָ�����͡�
//�������������б����ز�������ʽ�뺯������һ�¡�
func (���������� ����������) ������(�����б�) (���ز���) {
    ������
}
```
ʵ��
```go
//����һ���ṹ��
type rect struct {
    width, height int
}
//Ϊ�ṹ�嶨�巽��
func (r *rect) area() int {
    return r.width * r.height
}
//Ϊ�ṹ�嶨�巽��
func (r rect) perim() int {
    return 2*r.width + 2*r.height
}

func main() {
    r := rect{width: 10, height: 5}

    fmt.Println("area: ", r.area())
    fmt.Println("perim:", r.perim())

    rp := &r
    fmt.Println("area: ", rp.area())
    fmt.Println("perim:", rp.perim())
}
```

### �ӿ�
Go��������Ȼû�д�ͳ��������������࣬���ɵĸ�������ṩ�˽ӿڵ�֧�֣�����ʹ��
�ӿ���ʹ��һЩ����������Ч����Go�����нӿ��������ض�
* ���԰���0������������ǩ��
* ֻ���巽����ǩ����������ʵ��
* ʵ�ֽӿڲ���Ҫ��ʽ��������ֻ��ʵ����Ӧ��������
```go

//����ӿ�
type Shaper interface {
    Area() float32
    Circumference() float32
}

//����ṹ�岢��ʵ�ֽӿ�
type Rect struct {
    Width float32
    Height float32
}
func (r Rect) Area() int {
    return r.Width * r.Height
}

func (r Rect) Circumference() int {
    return 2 * (r.Width + r.Height)
}

//����ṹ�岢��ʵ�ֽӿ�
type Circle struct {
    Radius float32
}
func (c Circle) Area() int {
    return math.Pi * c.Radius * c.Radius
}

func (c Circle) Circumference() int {
    return math.Pi * 2 * c.Radius
}

func showInfo(s Shaper) {
    fmt.Printf("Area: %f, Circumference: %f", s.Area(), s.Circumference())
}

//�ӿڵĵ���
func main() {
    r := Rect{10, 20}
    showInfo(r)

    c := Circle{5}
    showInfo(r)    
}

//�������ʹ�����Ͷ��ԣ����ж�ĳһʱ�̽ӿ��Ƿ���ĳ����������
v, ok := s.(Rect)   // s ��һ���ӿ�����

//switch ������������������һ��ʵ����ֵ���ַ������жϣ�����һ���������;�����ж�һ���ӿ��ڱ����ʵ�ֵ����͡�
func printType(v interface{}) {
    switch v.(type) {
    case int:
        fmt.Println(v, "is int")
    case string:
        fmt.Println(v, "is string")
    case bool:
        fmt.Println(v, "is bool")
    }
}
func main() {
    printType(1024)
    printType("pig")
    printType(true)
}
```

### ��
Go����ֻ��һ���ļ����ļ������һ��main�����ͼ��������ĺ�������������֯GoԴ���룬�ṩ�˸��õĿ���������ɶ�д��


### Go�Ĳ���
#### goroutine
goroutine �ĸ����������̣߳��� goroutine �� Go ��������ʱ�ĵ��Ⱥ͹���Go ��������ܵؽ� goroutine �е��������ط����ÿ�� CPU��
Go�����п�������go�ؼ���Ϊһ����������һ��gorounite��һ���������Ա�������� goroutine��һ�� goroutine �ض���Ӧһ��������

```go
func running() {
    var times int
    // ����һ������ѭ��
    for {
        times++
        fmt.Println("tick", times)
        // ��ʱ1��
        time.Sleep(time.Second)
    }
}
func main() {
    // ����ִ�г���
    // ����go��һ����ͨ����ת��Ϊgoroutine
    go running()
    // ��������������, �����κ�����
    var input string
    fmt.Scanln(&input)
    
    //����go��һ����������ת��Ϊgoroutine
     go func() {
            var times int
            for {
                times++
                fmt.Println("tick", times)
                time.Sleep(time.Second)
            }
     }()
}
```


### GO �ı�׼��
```bash
Go���Ա�׼�����	��  ��
bufio	������� I/O ����
bytes	ʵ���ֽڲ���
container	��װ�ѡ��б�ͻ����б������
crypto	�����㷨
database	���ݿ������ͽӿ�
debug	���ֵ����ļ���ʽ���ʼ����Թ���
encoding	�����㷨�� JSON��XML��Base64 ��
flag	�����н���
fmt	��ʽ������
go	Go ���ԵĴʷ����﷨�������͵ȡ���ͨ����������д�����Ϣ��ȡ���޸�
html	HTML ת�弰ģ��ϵͳ
image	����ͼ�θ�ʽ�ķ��ʼ�����
io	ʵ�� I/O ԭʼ���ʽӿڼ����ʷ�װ
math	��ѧ��
net	����⣬֧�� Socket��HTTP���ʼ���RPC��SMTP ��
os	����ϵͳƽ̨������ƽ̨������װ
path	���ݸ�����ϵͳ��·������ʵ�ú���
plugin	Go 1.7 ����Ĳ��ϵͳ��֧�ֽ��������Ϊ������������
reflect	���Է���֧�֡����Զ�̬��ô����е�������Ϣ����ȡ���޸ı�����ֵ
regexp	������ʽ��װ
runtime	����ʱ�ӿ�
sort	����ӿ�
strings	�ַ���ת����������ʵ�ú���
time	ʱ��ӿ�
text	�ı�ģ�弰 Token �ʷ���
```



## ���뿪���淶
˵�����Ļ��ܶ�ʱ�򶼾���Goland���Ǹ�С������ߣ��ܶ�ʱ��д��д�žͱ����ˡ������Ҫһ���淶����������������


### ����ע��
    //@Document         �ĵ�ע��
    //@Func(�ɺ���)      ����ע��

## ���߽̳�
[Golang��׼���ĵ�](https://studygolang.com/pkgdoc)

[go���Ž̳�](http://c.biancheng.net/golang/)

[go����ָ��](https://books.studygolang.com/the-way-to-go_ZH_CN/)

[ѧϰgo�ı�׼��](https://books.studygolang.com/The-Golang-Standard-Library-by-Example/)

[go by example](https://books.studygolang.com/gobyexample/)

