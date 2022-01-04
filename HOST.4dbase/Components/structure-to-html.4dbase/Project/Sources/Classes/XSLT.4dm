Class constructor
	
	This:C1470.PROJECT:=This:C1470.getProjectFolder()
	This:C1470.RESOURCES:=This:C1470.getResourcesFolder()
	This:C1470.XSLT:=This:C1470.getFolder()
	This:C1470.HTML:=This:C1470.getFileHtml()
	This:C1470.IMAGES:=This:C1470.getFolderImages()
	
Function show($text : Text)
	
	$tempFolder:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Generate UUID:C1066)
	$tempFolder.create()
	This:C1470.IMAGES.copyTo($tempFolder)
	
	$file:=$tempFolder.file("catalog.html")
	$file.setText($text; "utf-8")
	
	OPEN URL:C673($file.platformPath)
	
Function getFolderImages()->$folder : 4D:C1709.Folder
	
	$folder:=Folder:C1567(fk resources folder:K87:11).folder("images")
	
Function getProjectFolder()->$folder : 4D:C1709.Folder
	
	$folder:=Folder:C1567(Get 4D folder:C485(Database folder:K5:14); fk platform path:K87:2)
	
Function getResourcesFolder()->$folder : 4D:C1709.Folder
	
	$folder:=Folder:C1567(Get 4D folder:C485(Current resources folder:K5:16); fk platform path:K87:2)
	
Function toHtml($catalog : 4D:C1709.File; $params : Object)->$status : Object
	
	$status:=This:C1470.apply(This:C1470.HTML; $catalog; $params)
	
Function apply($xsl : 4D:C1709.File; $catalog : 4D:C1709.File; $params : Object)->$status : Object
	
	$status:=New object:C1471("success"; False:C215)
	
	var $param; $stringparam : Text
	
	If (Not:C34(OB Is empty:C1297($params)))
		For each ($param; $params)
			Case of 
				: (Value type:C1509($params[$param])=Is real:K8:4)
					$stringparam:=$stringparam+" --param "+$param+" "+String:C10($params[$param]; "&xml;")
				: (Value type:C1509($params[$param])=Is boolean:K8:9)
					$stringparam:=$stringparam+" --param "+$param+" "+String:C10(Num:C11($params[$param]); "true();;false()")
				Else 
					$stringValue:=String:C10($params[$param])
					If (Length:C16($stringValue)#0)
						$stringparam:=$stringparam+" --stringparam "+$param+" \""+Replace string:C233($stringValue; "\""; "\""; *)+"\""
					End if 
			End case 
		End for each 
	End if 
	
	If (Is macOS:C1572)
		
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; This:C1470.XSLT.platformPath)
		
		$arguments:=$stringparam+" "+This:C1470.escape($xsl.path)
		$arguments:=$arguments+" "+This:C1470.escape($catalog.path)
		$command:="xsltproc"+$arguments
		
	Else 
		
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
		
		$arguments:=$stringparam+" "+This:C1470.escape($xsl.platformPath)
		$arguments:=$arguments+" "+This:C1470.escape($catalog.platformPath)
		$command:=This:C1470.escape(This:C1470.XSLT.file("xsltproc.exe").platformPath)+$arguments
		
	End if 
	
	var $pid : Integer
	C_BLOB:C604($stdIn; $stdOut; $stdErr)
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "true")
	LAUNCH EXTERNAL PROCESS:C811($command; $stdIn; $stdOut; $stdErr)
	
	$status.success:=(OK=1) & (BLOB size:C605($stdOut)#0)
	
	$status.stdErr:=Convert to text:C1012($stdErr; "utf-8")
	$status.result:=Convert to text:C1012($stdOut; "utf-8")
	
Function getFileHtml()->$file : 4D:C1709.File
	
	$file:=This:C1470.RESOURCES.file("structure_to_html.xsl")
	
Function getFolder()->$folder : 4D:C1709.Folder
	
	Case of 
		: (Is macOS:C1572)
			
			$folder:=This:C1470.PROJECT.folder("XSLT").folder("MacOS")
			
		: (Is Windows:C1573)
			
			$folder:=This:C1470.PROJECT.folder("XSLT").folder("Windows64")
			
	End case 
	
Function escape($in : Text)->$out : Text
	
	If (Count parameters:C259#0)
		
		$in:=$1
		
		C_LONGINT:C283($i; $len)
		
		If (Is Windows:C1573)
			
			//argument escape for cmd.exe; other commands (curl, ruby, etc.) may be incompatible
			
			$shoudQuote:=False:C215
			
			$metacharacters:="&|<>()%^\" "
			
			$len:=Length:C16($metacharacters)
			
			For ($i; 1; $len)
				$metacharacter:=Substring:C12($metacharacters; $i; 1)
				$shoudQuote:=$shoudQuote | (Position:C15($metacharacter; $in; *)#0)
				If ($shoudQuote)
					$i:=$len
				End if 
			End for 
			
			If ($shoudQuote)
				If (Substring:C12($in; Length:C16($in))="\\")
					$in:="\""+$in+"\\\""
				Else 
					$in:="\""+$in+"\""
				End if 
			End if 
			
		Else 
			
			$metacharacters:="\\!\"#$%&'()=~|<>?;*`[] "
			
			For ($i; 1; Length:C16($metacharacters))
				$metacharacter:=Substring:C12($metacharacters; $i; 1)
				$in:=Replace string:C233($in; $metacharacter; "\\"+$metacharacter; *)
			End for 
			
		End if 
		
	End if 
	
	$out:=$in