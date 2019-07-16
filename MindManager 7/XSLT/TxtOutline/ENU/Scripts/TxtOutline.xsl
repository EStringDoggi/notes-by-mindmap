<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:ap="http://schemas.mindjet.com/MindManager/Application/2003" xmlns:cor="http://schemas.mindjet.com/MindManager/Core/2003">

<xsl:import href="../../../Common/GetTopicTitle.xsl" />

<xsl:output method="text" />

	
<!-- ================================================================ -->
<!-- Customizable variables -->
<!-- ================================================================ -->

<xsl:variable name="centralTopicLine">
=============================================================
</xsl:variable>
	
<xsl:variable name="mainTopicLine">
-------------------------------------------------------------
</xsl:variable>




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
			<xsl:call-template name="WriteTopic">
			<xsl:with-param name="topic" select="." />
			</xsl:call-template>
		
			<xsl:text>&#xA;</xsl:text>
			<xsl:text>&#xA;</xsl:text>
					
			<!-- go ahead with child topics -->
			<xsl:apply-templates/>
		</xsl:otherwise>
		
	</xsl:choose>
	
</xsl:template>



<!-- ================================================================ -->
<!-- Write topic to output tree -->	
<!-- ================================================================ -->

<xsl:template name="WriteTopic">
	<xsl:param name="topic" />

	<!-- head line -->
	<!-- =========================================== -->
	<xsl:call-template name="WriteLine">
		<xsl:with-param name="topic" select="." />
	</xsl:call-template>

	<!-- number -->
	<!-- =========================================== -->
	<xsl:number level="multiple" count="ap:Topic" from="ap:OneTopic/ap:Topic" />
	<xsl:text>&#x20;</xsl:text>

	<!-- topic title -->
	<!-- =========================================== -->
	<xsl:call-template name="GetTopicTitle">
		<xsl:with-param name="topic" select="." />
	</xsl:call-template>
	
	<!-- bottom line -->
	<!-- =========================================== -->
	<xsl:call-template name="WriteLine">
		<xsl:with-param name="topic" select="." />
	</xsl:call-template>

	<!-- notes -->
	<!-- =========================================== -->
	<xsl:variable name="notes" select="ap:NotesGroup/ap:NotesXhtmlData" />
	
	<xsl:if test="$notes">
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:apply-templates select="$notes"/>
	</xsl:if>

</xsl:template>



<!-- ================================================================ -->
<!-- Write line -->
<!-- ================================================================ -->

<xsl:template name="WriteLine">
	<xsl:param name="topic" />

	<xsl:variable name="level" select="count($topic/ancestor::ap:Topic)" />
	
	<xsl:choose>
		<xsl:when test="$level = 0">
			<xsl:value-of select="$centralTopicLine" />
		</xsl:when>
		<xsl:when test="$level = 1">
			<xsl:value-of select="$mainTopicLine" />
		</xsl:when>
	</xsl:choose>
	
</xsl:template>
	
	
	
<!-- ================================================================ -->
<!-- Formatting of tables in text notes -->
<!-- ================================================================ -->

<xsl:template match="xhtml:table">

	<xsl:variable name="table">
		<xsl:apply-templates />
	</xsl:variable>
	
	<xsl:text>&#xA;</xsl:text>
	<xsl:call-template name="PrettyPrintTable">
		<xsl:with-param name="table" select="$table" />
	</xsl:call-template>
	<xsl:text>&#xA;</xsl:text>
	
</xsl:template>

<xsl:template match="xhtml:tr">
	<xsl:apply-templates />
	<xsl:text>&#xA;</xsl:text>
	<xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="xhtml:td">
	<xsl:apply-templates />
	<xsl:text>&#x9;</xsl:text>
</xsl:template>

<xsl:template match="xhtml:td/xhtml:div">
	<xsl:text>&#x20;</xsl:text>
	<xsl:apply-templates />
</xsl:template>

<xsl:template name="PrettyPrintTable">
	<xsl:param name="table" />
	
	<xsl:variable name="cellWidth">
		<xsl:call-template name="GetCellWidthOfTable">
			<xsl:with-param name="table" select="$table" />
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="prettyPrintedTable">
		<xsl:call-template name="PrettyPrintTableHelper">
			<xsl:with-param name="table" select="$table" />
			<xsl:with-param name="cellWidth" select="$cellWidth" />
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:value-of select="$prettyPrintedTable" />

</xsl:template>

<xsl:template name="PrettyPrintTableHelper">
	<xsl:param name="table" />
	<xsl:param name="cellWidth" />
	
	<xsl:variable name="firstRow" select="substring-before($table, '&#xA;&#xA;')" />
	<xsl:variable name="remainder" select="substring-after($table, '&#xA;&#xA;')" />

	<xsl:variable name="prettyPrintedRow">
		<xsl:call-template name="PrettyPrintRow">
			<xsl:with-param name="row" select="$firstRow" />
			<xsl:with-param name="cellWidth" select="$cellWidth" />
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:choose>
		<xsl:when test="$remainder=''">
			<xsl:value-of select="$prettyPrintedRow" />
		</xsl:when>
		
		<xsl:otherwise>
			<xsl:variable name="prettyPrintedRemainder">
				<xsl:call-template name="PrettyPrintTableHelper">
					<xsl:with-param name="table" select="$remainder" />
					<xsl:with-param name="cellWidth" select="$cellWidth" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="concat($prettyPrintedRow, '&#xA;&#xA;', $prettyPrintedRemainder)" />
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>

<xsl:template name="PrettyPrintRow">
	<xsl:param name="row" />
	<xsl:param name="cellWidth" />
	
	<xsl:variable name="firstCell" select="substring-before($row, '&#x9;')" />
	<xsl:variable name="firstCellWidth" select="string-length('$firstCell')" />
	<xsl:variable name="remainder" select="substring-after($row, '&#x9;')" />

	<xsl:variable name="prettyPrintedCell">
		<xsl:call-template name="PrettyPrintCell">
			<xsl:with-param name="cell" select="normalize-space($firstCell)" />
			<xsl:with-param name="cellWidth" select="$cellWidth" />
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:choose>
		<xsl:when test="$remainder=''">
			<xsl:value-of select="$prettyPrintedCell" />
		</xsl:when>
		
		<xsl:otherwise>
			<xsl:variable name="prettyPrintedRemainder">
				<xsl:call-template name="PrettyPrintRow">
					<xsl:with-param name="row" select="$remainder" />
					<xsl:with-param name="cellWidth" select="$cellWidth" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="concat($prettyPrintedCell, '&#x9;', $prettyPrintedRemainder)" />
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>

<xsl:template name="PrettyPrintCell">
	<xsl:param name="cell" />
	<xsl:param name="cellWidth" />
	
	<xsl:choose>
		<xsl:when test="string-length($cell)>=$cellWidth">
			<xsl:value-of select="$cell" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="PrettyPrintCell">
				<xsl:with-param name="cell" select="concat($cell, '&#x20;')" />
				<xsl:with-param name="cellWidth" select="$cellWidth" />
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>
	
<xsl:template name="GetCellWidthOfTable">
	<xsl:param name="table" />

	<xsl:choose>
	
		<xsl:when test="$table=''">0</xsl:when>
		
		<xsl:otherwise>
			<xsl:variable name="firstRow" select="substring-before($table, '&#xA;&#xA;')" />
			<xsl:variable name="firstRowMaxWidth">
				<xsl:call-template name="GetCellWidthOfRow">
					<xsl:with-param name="row" select="$firstRow" />
				</xsl:call-template>
			</xsl:variable>
				
			<xsl:variable name="remainder" select="substring-after($table, '&#xA;&#xA;')" />
			<xsl:variable name="remainderMaxWidth">
				<xsl:call-template name="GetCellWidthOfTable">
					<xsl:with-param name="table" select="$remainder" />
				</xsl:call-template>
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="$firstRowMaxWidth>$remainderMaxWidth">
					<xsl:value-of select="$firstRowMaxWidth" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$remainderMaxWidth" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
		
	</xsl:choose>

</xsl:template>

<xsl:template name="GetCellWidthOfRow">
	<xsl:param name="row" />

	<xsl:choose>
	
		<xsl:when test="$row=''">0</xsl:when>
		
		<xsl:otherwise>
			<xsl:variable name="firstCell" select="substring-before($row, '&#x9;')" />
			<xsl:variable name="firstCellWidth" select="string-length(normalize-space($firstCell))" />
			<xsl:variable name="remainder" select="substring-after($row, '&#x9;')" />
			<xsl:variable name="remainderMaxWidth">
				<xsl:call-template name="GetCellWidthOfRow">
					<xsl:with-param name="row" select="$remainder" />
				</xsl:call-template>
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="$firstCellWidth>$remainderMaxWidth">
					<xsl:value-of select="$firstCellWidth" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$remainderMaxWidth" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
		
	</xsl:choose>

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
