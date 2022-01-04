![version](https://img.shields.io/badge/version-19%2B-5682DF)
[![license](https://img.shields.io/github/license/miyako/4d-class-build-application
)](LICENSE)

# 4d-utility-structure-to-html
XSLT wrapper to simulate old 32-bit feature

#### Usage

```4d
$XSLT:=XSLT  //a shared component class

$o:=$XSLT.new()

//must pass full platform path
$catalog:=Folder(Get 4D folder(Current resources folder); fk platform path).file("InvoicesDemo.xml")

//must run in local project (i.e. on the server)
$status:=$o.toHtml($catalog)
If ($status.success)
	$o.show($status.result)
End if 
```

#### Example Output 

<img width="664" alt="ss" src="https://user-images.githubusercontent.com/1725068/148091556-ab0f73d9-b51f-4f7f-ac87-2bce25f994f0.png">

### Features

* `xsltproc` is universal (Apple Silicon+Intel) and static.
* `xsltproc` is codesigned and notarised.
* also Windows 64-bit.
* shared component class, support binary mode.

The executable is intentionally outside of `/RESOURCES/` to avoid invalid signature and bad UNIX permisson on client/server.
