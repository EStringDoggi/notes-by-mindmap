<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:ap="http://schemas.mindjet.com/MindManager/Application/2003" xmlns:cor="http://schemas.mindjet.com/MindManager/Core/2003">
<xsl:output method="text" />


<!-- ================================================================ -->
<!-- Get a topic's title -->
<!-- Use the ink-recognition-result or the style if no title is set -->
<!-- ================================================================ -->

<xsl:template name="GetTopicTitle">
	<xsl:param name="topic" />
	
	<xsl:variable name="title" select="$topic/ap:Text/@PlainText" />

	<xsl:choose>
		<xsl:when test="$title">
			<!-- title attribute is available, but it could be the empty string -->
			<!-- in this case, we check whether there is some ink recognition available -->
			<xsl:choose>
				<xsl:when test="$title=''">
					<xsl:variable name="recognition">
						<xsl:value-of select="$topic/ap:InkGroup/ap:InkRecognitionResult/@PlainText" />
					</xsl:variable>
					<xsl:variable name="firstResult" select="substring-before($recognition, ';')" />
					<xsl:choose>
						<xsl:when test="$firstResult=''">
							<xsl:value-of select="$recognition" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$firstResult" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$title"></xsl:value-of>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<!-- no title found / get the style's default title -->
			<xsl:call-template name="GetStyleTitle">
				<xsl:with-param name="topic" select="$topic" />
			</xsl:call-template>		
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>



<!-- ================================================================ -->
<!-- Get a topic's style title -->
<!-- ================================================================ -->

<xsl:template name="GetStyleTitle">
	<xsl:param name="topic" />
		
	<xsl:variable name="rootType">
		<xsl:call-template name="GetStyleRootTypeHelper">
			<xsl:with-param name="topic" select="$topic" />
		</xsl:call-template>	
	</xsl:variable>
	
	<xsl:variable name="level">
		<xsl:call-template name="GetStyleLevelHelper">
			<xsl:with-param name="topic" select="$topic" />
		</xsl:call-template>	
	</xsl:variable>

	<xsl:choose>
	
		<xsl:when test="contains($rootType, 'Central')">
			<xsl:call-template name="GetStyleTitleHelperForStandardTopics">
				<xsl:with-param name="level" select="$level" />
			</xsl:call-template>	
		</xsl:when>
		
		<xsl:when test="contains($rootType, 'Callout')">
			<xsl:call-template name="GetStyleTitleHelperForCalloutTopics">
				<xsl:with-param name="level" select="$level" />
			</xsl:call-template>	
		</xsl:when>

		<xsl:when test="contains($rootType, 'Label')">
			<xsl:call-template name="GetStyleTitleHelperForLabelTopics">
				<xsl:with-param name="level" select="$level" />
			</xsl:call-template>	
		</xsl:when>

	</xsl:choose>
	
</xsl:template>



<!-- ================================================================ -->
<!-- Get a topic's root in terms of style values -->
<!-- ================================================================ -->
<!-- the root of a topic in terms of style can be -->
<!-- the cental topic, -->
<!-- a callout -->
<!-- or a label -->
<!-- ================================================================ -->

<xsl:template name="GetStyleRootTypeHelper">
	<xsl:param name="topic" />
		
	<xsl:variable name="parentContainer" select="$topic/parent::node()" />
	<xsl:variable name="parentTopic" select="$parentContainer/parent::node()" />
	<xsl:variable name="parentTopicParentContainer" select="$parentTopic/parent::node()" />

	
	<xsl:choose>	
	
		<xsl:when test="name($parentContainer)='ap:OneTopic'">
			Central
		</xsl:when>
		
		<xsl:when test="name($parentContainer)='ap:FloatingTopics'">
			<xsl:choose>
				<xsl:when test="name($parentTopicParentContainer)='ap:OneTopic'">
					Label
				</xsl:when>
				<xsl:otherwise>
					Callout
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		
		<xsl:otherwise>
			<xsl:call-template name="GetStyleRootTypeHelper">
				<xsl:with-param name="topic" select="$parentTopic" />
			</xsl:call-template>
		</xsl:otherwise>
		
	</xsl:choose>

</xsl:template>



<!-- ================================================================ -->
<!-- Get a topic's level terms of style values -->
<!-- ================================================================ -->

<xsl:template name="GetStyleLevelHelper">
	<xsl:param name="topic" />
			
	<xsl:variable name="parentContainer" select="$topic/parent::node()" />
	<xsl:variable name="parentTopic" select="$parentContainer/parent::node()" />
	
	<xsl:choose>	
	
		<xsl:when test="name($parentContainer)='ap:OneTopic'">
			-1
		</xsl:when>
		
		<xsl:when test="name($parentContainer)='ap:FloatingTopics'">
			-1
		</xsl:when>
		
		<xsl:otherwise>
		
			<xsl:variable name="levelOfParent">
				<xsl:call-template name="GetStyleLevelHelper">
					<xsl:with-param name="topic" select="$parentTopic" />
				</xsl:call-template>
			</xsl:variable>
			
			<xsl:value-of select="$levelOfParent + 1" />
			
		</xsl:otherwise>
		
	</xsl:choose>

</xsl:template>



<!-- ================================================================ -->
<!-- Get style title for standard topics -->
<!-- ================================================================ -->

<xsl:template name="GetStyleTitleHelperForStandardTopics">
	<xsl:param name="level" />
			
	<xsl:choose>
	
		<!-- test for root -->
		<!-- =========================================== -->
		<xsl:when test="$level = -1">
			<xsl:value-of select="/ap:Map/ap:StyleGroup/ap:RootTopicDefaultsGroup/ap:DefaultText/@PlainText" />
		</xsl:when>
		
		<!-- start recursion to find level -->
		<!-- =========================================== -->
		<xsl:otherwise>

			<xsl:variable name="title" select="/ap:Map/ap:StyleGroup/ap:RootSubTopicDefaultsGroup[@Level=($level)]/ap:DefaultText/@PlainText" />

			<xsl:choose>
			
				<xsl:when test="$title">
					<xsl:value-of select="$title" />
				</xsl:when>
			
				<xsl:otherwise>
					<xsl:call-template name="GetStyleTitleHelperForStandardTopics">
						<xsl:with-param name="level" select="$level - 1" />
					</xsl:call-template>
				</xsl:otherwise>	
			</xsl:choose>
			
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>



<!-- ================================================================ -->
<!-- Get style title for callout topics -->
<!-- ================================================================ -->

<xsl:template name="GetStyleTitleHelperForCalloutTopics">
	<xsl:param name="level" />
			
	<xsl:choose>
	
		<!-- test for root -->
		<!-- =========================================== -->
		<xsl:when test="$level = -1">
			<xsl:value-of select="/ap:Map/ap:StyleGroup/ap:CalloutTopicDefaultsGroup/ap:DefaultText/@PlainText" />
		</xsl:when>
		
		<!-- start recursion to find level -->
		<!-- =========================================== -->
		<xsl:otherwise>

			<xsl:variable name="title" select="/ap:Map/ap:StyleGroup/ap:CalloutSubTopicDefaultsGroup[@Level=($level)]/ap:DefaultText/@PlainText" />

			<xsl:choose>
			
				<xsl:when test="$title">
					<xsl:value-of select="$title" />
				</xsl:when>
			
				<xsl:otherwise>
					<xsl:call-template name="GetStyleTitleHelperForCalloutTopics">
						<xsl:with-param name="level" select="$level - 1" />
					</xsl:call-template>
				</xsl:otherwise>	
			</xsl:choose>
			
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>



<!-- ================================================================ -->
<!-- Get style title for label topics -->
<!-- ================================================================ -->

<xsl:template name="GetStyleTitleHelperForLabelTopics">
	<xsl:param name="level" />
			
	<xsl:choose>
	
		<!-- test for root -->
		<!-- =========================================== -->
		<xsl:when test="$level = -1">
			<xsl:value-of select="/ap:Map/ap:StyleGroup/ap:LabelTopicDefaultsGroup/ap:DefaultText/@PlainText" />
		</xsl:when>
		
		<!-- start recursion to find level -->
		<!-- =========================================== -->
		<xsl:otherwise>

			<xsl:variable name="title" select="/ap:Map/ap:StyleGroup/ap:LabelSubTopicDefaultsGroup[@Level=($level)]/ap:DefaultText/@PlainText" />

			<xsl:choose>
			
				<xsl:when test="$title">
					<xsl:value-of select="$title" />
				</xsl:when>
			
				<xsl:otherwise>
					<xsl:call-template name="GetStyleTitleHelperForLabelTopics">
						<xsl:with-param name="level" select="$level - 1" />
					</xsl:call-template>
				</xsl:otherwise>	
			</xsl:choose>
			
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>



</xsl:stylesheet>
