<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:ap="http://schemas.mindjet.com/MindManager/Application/2003" xmlns:cor="http://schemas.mindjet.com/MindManager/Core/2003">

<xsl:include href="../../../Common/GetTopicTitle.xsl" />

<xsl:output method="html"/>

	
<!-- ================================================================ -->
<!-- Customizable variables -->
<!-- ================================================================ -->

<xsl:variable name="maxLevel" select="5" />

<xsl:variable name="level1Indent" select="'margin-left:  2em'" />

<xsl:variable name="level2Indent" select="'margin-left:  4em'" />

<xsl:variable name="level3Indent" select="'margin-left:  6em'" />

<xsl:variable name="level4Indent" select="'margin-left:  8em'" />

<xsl:variable name="level5Indent" select="'margin-left:  10em'" />

<xsl:variable name="levelXIndent" select="'margin-left:  12em'" />

<xsl:variable name="level1Style" select="'font-size: 11pt; font-weight: bold; margin-bottom: 0.5em; margin-left:  2em'" />

<xsl:variable name="level2Style" select="'font-size:  9pt; font-weight: bold; margin-top: 1em; margin-bottom: 0.5em'" />

<xsl:variable name="level3Style" select="'font-size:  8pt; font-weight: bold; margin-top: 1em; margin-bottom: 0.5em'" />

<xsl:variable name="level4Style" select="'font-size:  8pt; font-weight: bold; margin-top: 1em; margin-bottom: 0.5em'" />

<xsl:variable name="level5Style" select="'font-size:  8pt; font-weight: bold; margin-top: 1em; margin-bottom: 0.5em'" />

<xsl:variable name="levelXStyle" select="'font-size:  8pt; font-weight: bold; margin-top: 1em; margin-bottom: 0.5em'" />

<xsl:variable name="notesStyle" select="'font-size:  8pt; margin-bottom: 1em'" />



<!-- ================================================================ -->
<!-- Create Outline -->
<!-- ================================================================ -->
<xsl:template match="ap:Map">

	<html>
	<head>
		<title>Outline of <xsl:value-of select="ap:OneTopic/ap:Topic/ap:Text/@PlainText"/></title>
		<xsl:call-template name="CreateStyles" />
	</head>
	<body>
			
	<!-- go ahead with topics -->
	<xsl:apply-templates/>
			
	</body>
	</html>
	
</xsl:template>



<!-- ================================================================ -->
<!-- Create Topic -->	
<!-- ================================================================ -->

<xsl:template match="ap:Topic">

	<xsl:variable name="hidden" select="ap:TopicViewGroup/ap:Visibility/@Hidden" />
	
	<xsl:choose>
	
	<xsl:when test="$hidden = 'true'">
		<!-- this topic is filtered, so we don't process it -->
	</xsl:when>
	
	<xsl:otherwise>
			
	<xsl:variable name="level" select="count(ancestor::ap:Topic) + 1" />
	
	<xsl:variable name="styleLevel">
		<xsl:choose>
			<xsl:when test="$level>$maxLevel">X</xsl:when>
			<xsl:otherwise><xsl:value-of select="$level" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	
	<div id="level{$styleLevel}Indent">
	
		<div id="level{$styleLevel}Style">			
			<xsl:number level="multiple" count="ap:Topic" from="ap:OneTopic/ap:Topic" />
			<xsl:text>&#x20;</xsl:text>

			<xsl:call-template name="GetTopicTitle">
				<xsl:with-param name="topic" select="." />
			</xsl:call-template>
		</div>
			
		<xsl:call-template name="CreateNotes">
			<xsl:with-param name="topicNotes" select="ap:NotesGroup/ap:NotesXhtmlData/xhtml:html" />
		</xsl:call-template>
		
	</div>

	<xsl:apply-templates/>
	
	</xsl:otherwise>
	</xsl:choose>

</xsl:template>



<!-- ================================================================ -->
<!-- Create Notes -->	
<!-- ================================================================ -->

<xsl:template name="CreateNotes">
	<xsl:param name="topicNotes" />
	
	<xsl:if test="$topicNotes">
		<div id="notesStyle">
			<xsl:for-each select="$topicNotes/child::node()">
				<xsl:copy>
					<xsl:apply-templates select="@* | * | text()" mode="CreateNotesMode" />
				</xsl:copy>
			</xsl:for-each>
		</div>
	</xsl:if>
	
</xsl:template>

<xsl:template match="@* | * | text()" mode="CreateNotesMode">
	<xsl:copy><xsl:apply-templates select="@* | * | text()" mode="CreateNotesMode" /></xsl:copy>
</xsl:template>

<xsl:template match="xhtml:img" mode="CreateNotesMode" />



<!-- ================================================================ -->
<!-- Create Styles -->	
<!-- ================================================================ -->

<xsl:template name="CreateStyles">

	<xsl:call-template name="CreateStyle">
		<xsl:with-param name="name" select="'#level1Indent'" />
		<xsl:with-param name="style" select="$level1Indent" />
	</xsl:call-template>
	
	<xsl:call-template name="CreateStyle">
		<xsl:with-param name="name" select="'#level2Indent'" />
		<xsl:with-param name="style" select="$level2Indent" />
	</xsl:call-template>

	<xsl:call-template name="CreateStyle">
		<xsl:with-param name="name" select="'#level3Indent'" />
		<xsl:with-param name="style" select="$level3Indent" />
	</xsl:call-template>

	<xsl:call-template name="CreateStyle">
		<xsl:with-param name="name" select="'#level4Indent'" />
		<xsl:with-param name="style" select="$level4Indent" />
	</xsl:call-template>

	<xsl:call-template name="CreateStyle">
		<xsl:with-param name="name" select="'#level5Indent'" />
		<xsl:with-param name="style" select="$level5Indent" />
	</xsl:call-template>
	
	<xsl:call-template name="CreateStyle">
		<xsl:with-param name="name" select="'#levelXIndent'" />
		<xsl:with-param name="style" select="$levelXIndent" />
	</xsl:call-template>
	
	<xsl:call-template name="CreateStyle">
		<xsl:with-param name="name" select="'#level1Style'" />
		<xsl:with-param name="style" select="$level1Style" />
	</xsl:call-template>
	
	<xsl:call-template name="CreateStyle">
		<xsl:with-param name="name" select="'#level2Style'" />
		<xsl:with-param name="style" select="$level2Style" />
	</xsl:call-template>

	<xsl:call-template name="CreateStyle">
		<xsl:with-param name="name" select="'#level3Style'" />
		<xsl:with-param name="style" select="$level3Style" />
	</xsl:call-template>

	<xsl:call-template name="CreateStyle">
		<xsl:with-param name="name" select="'#level4Style'" />
		<xsl:with-param name="style" select="$level4Style" />
	</xsl:call-template>

	<xsl:call-template name="CreateStyle">
		<xsl:with-param name="name" select="'#level5Style'" />
		<xsl:with-param name="style" select="$level5Style" />
	</xsl:call-template>
	
	<xsl:call-template name="CreateStyle">
		<xsl:with-param name="name" select="'#levelXStyle'" />
		<xsl:with-param name="style" select="$levelXStyle" />
	</xsl:call-template>
	
	<xsl:call-template name="CreateStyle">
		<xsl:with-param name="name" select="'#notesStyle'" />
		<xsl:with-param name="style" select="$notesStyle" />
	</xsl:call-template>

</xsl:template>


<xsl:template name="CreateStyle">
	<xsl:param name="name" />
	<xsl:param name="style" />
	
	<style type="text/css">
		<xsl:value-of select="$name" />
		<xsl:text> { </xsl:text>
		<xsl:value-of select="$style" />
		<xsl:text> } </xsl:text>
 	</style>

</xsl:template>



<!-- ================================================================ -->
<!-- Avoid processing these nodes -->
<!-- ================================================================ -->

<xsl:template match="ap:NotesGroup" />
<xsl:template match="ap:DocumentGroup" />
<xsl:template match="ap:StyleGroup" />
<xsl:template match="ap:MapViewGroup" />
<xsl:template match="ap:MarkersSetGroup" />
<xsl:template match="ap:FloatingTopics/ap:Topic" />
<xsl:template match="ap:OneImage" />
<xsl:template match="cor:Base64" />


</xsl:stylesheet>
