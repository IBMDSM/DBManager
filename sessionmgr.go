package main

import (
  "fmt"
  "net/http"
  "os/exec"
  "os"
  "strings"
  "io/ioutil"
  "encoding/json"
)

// create a struct to store the json body. The members Must be in Uppercase
type PostBody struct {
  ServiceID string;
  Namespace string;
  ServiceNS string;
  InstanceID string;
  Username  string;
  Password  string
}
func curPath()(string){

  s, _ := exec.LookPath(os.Args[0])
  i := strings.LastIndex(s, "/")
  path := string(s[0 : i+1])

  return path

}
func ExeCmdLine(w http.ResponseWriter, cmdline string)(string,int){


   // Create rc
  fmt.Println(cmdline)
  cmdRC := exec.Command("/bin/sh","-c",cmdline)
  stdout, _ := cmdRC.StdoutPipe()
  stderr, _ := cmdRC.StderrPipe()
  err := cmdRC.Start()

  if err != nil {
     fmt.Println(err)
     fmt.Fprintf(w, "Start failed!")
     return "Start failed", 1
  }

  d, _ := ioutil.ReadAll(stdout)
  e, _ := ioutil.ReadAll(stderr)
  err = cmdRC.Wait();
  if err != nil {
     errstr:="Failed: "+string(d)+" "+ string(e)
     strings.Replace(errstr,"\n"," ",-1)
     fmt.Println(errstr)
     fmt.Fprintf(w, errstr)
     return errstr,1
  }

  str:=string(d)
  fmt.Println(str)
  strArr:=strings.Split(str, "\n")
  return strArr[len(strArr)-2],0


}
func CreateInstanceHandler (w http.ResponseWriter, r *http.Request) {
   // run kubectl to create new nginx-pod on the fly
   // Assumption:
   //   kubectl is installed
   //   kubectl is configured with the admin pri
  err := os.Setenv("KUBECONFIG","config")
  if err != nil {
     fmt.Println(err)

  }
  fmt.Println(os.Getenv("KUBECONFIG"))
  
  // get username, password param to authentication
  decoder := json.NewDecoder(r.Body)
  var postBody PostBody
  err = decoder.Decode(&postBody)

  username := postBody.Username
  password := postBody.Password
  // namespace param
  namespace := postBody.Namespace

  // get other parameters
  serviceID := postBody.ServiceID
  serviceNS := postBody.ServiceNS
  instanceID := postBody.InstanceID

  fmt.Println("Gotten username: " + username+ " password: "+password )
  fmt.Println("Namespaceargs: " + namespace)
  fmt.Println("service ID is: " + serviceID + " service name space: "+serviceNS+" instanceID is: "+instanceID)
  
 if Authentication(username,password) {
   // Create rc
  cmdline :=curPath()+"common_deploy.sh " +  namespace+ " "+serviceID + " "+ instanceID+" 1000"
  outstr,err:=ExeCmdLine(w,cmdline)

  if err==1 {
    return
  }
  //create service
  cmdline =curPath()+"common_deploy_svc.sh " +  namespace+ " "+serviceID + " "+ instanceID+" "+ outstr
  outstr,err=ExeCmdLine(w,cmdline)
  if err==1 {
    return
  } else{
    fmt.Fprintf(w, outstr)
  }

 }else{
 //authenciation did not pass, write error message
   fmt.Fprintf(w, "Auth failed!")
 }
}


func DeleteInstanceHandler (w http.ResponseWriter, r *http.Request) {
   // run kubectl to delete nginx-pod on the fly
   // Assumption:
   //   kubectl is installed
   //   kubectl is configured with the admin pri
  err := os.Setenv("KUBECONFIG","config")
  if err != nil {
     fmt.Println(err)

  }

 fmt.Println(os.Getenv("KUBECONFIG"))
  
  // get username, password param to authentication
  decoder := json.NewDecoder(r.Body) 
  var postBody PostBody
  err = decoder.Decode(&postBody)
  
  username := postBody.Username
  password := postBody.Password
  // namespace param
  namespace := postBody.Namespace
  namespaceArg := "--namespace="+namespace
  
  // get other parameters
  serviceID := postBody.ServiceID
  serviceNS := postBody.ServiceNS
  instanceID := postBody.InstanceID

  fmt.Println("Gotten username: " + username+ " password: "+password )
  fmt.Println("Namespaceargs: " + namespaceArg) 
  fmt.Println("service ID is: " + serviceID + " service name space: "+serviceNS+" instanceID is: "+instanceID)
  
  auth := Authentication(username,password) 
  fmt.Println("validating username and password: ")
  fmt.Println (auth)

 if auth {

  cmdline :=curPath()+"common_delete_svc.sh " +  namespace+" "+ serviceID + " "+ instanceID + " 20"

  outstr,err:=ExeCmdLine(w,cmdline)

  if err==1 {
    return
  }

  cmdline =curPath()+"common_delete.sh " +  namespace+" "+ serviceID + " "+ instanceID +" 20"
  outstr,err=ExeCmdLine(w,cmdline)
  if err==1 {
    return
  } else{
    fmt.Fprintf(w, outstr)
  }

} else{
 //authenciation didn't pass, do nothing
  fmt.Fprintf(w, "Auth failed!") 
}

}

func Authentication (user string,psw string) bool {
   // user and psw are gotten from post body 
   // Currently, only username equals "admin", password equals "password",
   // authentication could pass
  if user == "admin" && psw == "password" {
    fmt.Println("Validation passed") 
    return true
  }else{ 
     fmt.Println("Validation failed") 
     return false
  }
}


func main() {
   fmt.Println("Starting....")
   http.HandleFunc("/instance/create", CreateInstanceHandler)
   http.HandleFunc("/instance/delete", DeleteInstanceHandler)
   http.HandleFunc("/container/create", CreateInstanceHandler)
   http.HandleFunc("/container/delete", DeleteInstanceHandler)
   http.ListenAndServe(":8082", nil)
}

