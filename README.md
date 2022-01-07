![version](https://img.shields.io/badge/version-19%2B-5682DF)
[![license](https://img.shields.io/github/license/miyako/4d-class-build-application
)](LICENSE)

# 4d-utility-structure-to-html
XSLT wrapper to simulate old 32-bit feature

c.f. [Exporting and importing structure definitions](https://doc.4d.com/4Dv19/4D/19/Exporting-and-importing-structure-definitions.300-5416829.en.html)

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

### Remarks

The executable is intentionally outside of `/RESOURCES/` to avoid invalid signature and bad UNIX permisson on client/server.

The function takes advantage of `4D.File` and `4D.Folder` but file system paths must be avoided since the path is eventually passed to `LAUNCH EXTERNAL PROCESS`.

If you have trouble with `xsltproc` code signature, try install from [`.dmg`](https://github.com/miyako/4d-utility-structure-to-html/releases/tag/0.0.1).
