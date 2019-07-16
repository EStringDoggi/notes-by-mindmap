<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:ap="http://schemas.mindjet.com/MindManager/Application/2003" xmlns:rss="http://purl.org/rss/1.0/" xmlns:cor="http://schemas.mindjet.com/MindManager/Core/2003" exclude-result-prefixes="dc xhtml rdf rss xsl">
	<xsl:param name="imageLocation"/>
    <xsl:output method="xml"/>
    
    <!-- localization -->
    <!-- ======== -->
    
    <xsl:include href="language.xslt"/>
    <!-- templates   -->
    <!-- ======== -->
    
    <xsl:template match="/">
        <xsl:apply-templates select="rdf:RDF|rss" />
    </xsl:template>
    
    <xsl:template match="rdf:RDF">
        <xsl:call-template name="rss"/>
    </xsl:template>
    
    <xsl:template match="rss">
        <xsl:call-template name="rss"/>
    </xsl:template>
    
    <xsl:template match="dc:date">
        <ap:Topic>
            <ap:Text TextAlignment="urn:mindjet:Left">
                <xsl:attribute name="PlainText"><xsl:value-of select="$locDate"/><xsl:text> </xsl:text><xsl:value-of select="text()"/></xsl:attribute>
                <ap:Font Size="8" Color="ff008000"/>
                <ap:FontRange From="0" To="5" Bold="true"/>
            </ap:Text>
        </ap:Topic>
    </xsl:template>
    
    <xsl:template match="dc:creator">
        <ap:Topic>
            <ap:Text TextAlignment="urn:mindjet:Left">
                <xsl:attribute name="PlainText"><xsl:value-of select="$locCreator"/><xsl:text> </xsl:text><xsl:value-of select="dc:creator/text()"/></xsl:attribute>
                <ap:Font Size="8" Color="ff008000"/>
                <ap:FontRange From="0" To="8" Bold="true"/>
            </ap:Text>
        </ap:Topic>
    </xsl:template>
    
    <xsl:template name="viewGroup">
        <ap:TopicViewGroup ViewIndex="0">
            <ap:Collapsed Collapsed="true"/>
        </ap:TopicViewGroup>
    </xsl:template>
    
    <xsl:template match="rss:title | title" mode="item">
        <ap:Text TextAlignment="urn:mindjet:Left">
            <xsl:attribute name="PlainText"><xsl:value-of disable-output-escaping="yes" select="text()"/></xsl:attribute>
            <ap:Font/>
        </ap:Text>
    </xsl:template>
    
    <xsl:template match="xhtml:body">
        <ap:NotesGroup>
            <ap:NotesXhtmlData>
                <xsl:copy-of select="."/>
            </ap:NotesXhtmlData>
        </ap:NotesGroup>
    </xsl:template>
    
    <xsl:template match="rss:link | link">
        <ap:Hyperlink>
            <xsl:attribute name="Url"><xsl:value-of select="text()"/></xsl:attribute>
        </ap:Hyperlink>
    </xsl:template>
    
    <xsl:template name="item">
        <ap:Topic>
            <xsl:call-template name="viewGroup"/>
            <xsl:apply-templates select="rss:title" mode="item"/>
            <xsl:apply-templates select="title" mode="item"/>
            <xsl:choose>
				<xsl:when test="xhtml:body">
					<xsl:apply-templates select="xhtml:body"/>
				</xsl:when>
				<xsl:when test="rss:description">
					<xsl:apply-templates select="rss:description"/>
				</xsl:when>
				<xsl:when test="description">
					<xsl:apply-templates select="description"/>
				</xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="rss:link"/>
            <xsl:apply-templates select="link"/>
            <ap:SpellingOptions SpellText="false" SpellNotes="false"/>
        </ap:Topic>
    </xsl:template>
    
    <xsl:template name="boundary">
        <ap:OneBoundary>
            <ap:Boundary>
                <ap:BoundaryViewGroup ViewIndex="0"/>
                <ap:Color FillColor="ffd6d6d6" LineColor="ff999999"/>
                <ap:LineStyle LineWidth="0.5"/>
                <ap:BoundaryShape BoundaryShape="urn:mindjet:CurvedLine"/>
            </ap:Boundary>
        </ap:OneBoundary>
    </xsl:template>
    
    <xsl:template match="rss:title | title" mode="title">
        <ap:Text>
            <xsl:attribute name="PlainText"><xsl:value-of select="text()"/></xsl:attribute>
            <ap:Font/>
        </ap:Text>
    </xsl:template>
    
    <xsl:template match="rss:description | description">
        <ap:NotesGroup>
            <ap:NotesXhtmlData PreviewPlainText="">
                <html xmlns="http://www.w3.org/1999/xhtml">
                    <p>
                        <xsl:value-of select="parent::node()/pubDate"/>
                    </p>
                    <p>
                        <xsl:value-of select="text()"/>
                    </p>
                    <xsl:variable name="link" select="parent::node()/link" />
                    <xsl:if test="$link">
	                   	<p>
	                    	<a href="{$link}">
	                    		<xsl:value-of select="$notesHyperlinkName" />
	                    	</a>
	                    </p>
                    </xsl:if>
                </html>
            </ap:NotesXhtmlData>
        </ap:NotesGroup>
    </xsl:template>
    
    <xsl:template name="rss">
        <ap:Topic>
            <cor:Custom Uri="http://schemas.mindjet.com/MindManager/GSMP/2003" Index="0" custom0:Active="true" 
              custom0:ProgId="Mindjet.Rss.Smp.1" 
              custom0:FriendlyName="RSS" 
              custom0:InitTopicCommand="Refresh" 
              custom0:RefreshCommand="Refresh" 
              custom0:Command1="Description" 
              custom0:CommandCaption1="{$locDescription}" 
              custom0:CommandEnabled1="" 
              custom0:Command2="ConvertToRegular" 
              custom0:CommandCaption2="{$locConvertToRegular}" 
              custom0:CommandEnabled2="" 
              custom0:RefreshAllEnabled="" 
              custom0:RssUrl="http://myrss.com/f/c/n/cnnGf9z390.rss91" xmlns:custom0="http://schemas.mindjet.com/MindManager/GSMP/2003"/>
            <!-- custom0:SilentRefreshEnabled=""   'add this to cor:Custom to enable silent refresh-->
            <!-- boolean values like custom0:SilentRefreshEnabled="" are true if they exist and false if they do not exist-->
            <ap:SubTopics>
                <xsl:for-each select="channel/item">
                    <xsl:call-template name="item"/>
                </xsl:for-each>
                <xsl:for-each select="rss:item">
                    <xsl:call-template name="item"/>
                </xsl:for-each>
            </ap:SubTopics>
            <xsl:call-template name="boundary"/>
            <xsl:call-template name="viewGroup"/>
            <xsl:apply-templates select="channel/title" mode="title"/>
            <xsl:apply-templates select="rss:channel/rss:title" mode="title"/>
            <ap:Color LineColor="ff999999" FillColor="ffffffff"/>
            <xsl:apply-templates select="channel/description"/>
            <xsl:apply-templates select="rss:channel/rss:description"/>
			<ap:SubTopicShape SubTopicShape="urn:mindjet:RoundedRectangle"/>
            <xsl:call-template name="TopicLayout"/>
            <xsl:apply-templates select="channel/link"/>
            <xsl:apply-templates select="rss:channel/rss:link"/>
            <ap:SpellingOptions SpellText="false" SpellNotes="false"/>
        </ap:Topic>
    </xsl:template>
    
    <xsl:template name="TopicLayout">
		<ap:TopicLayout>
			<xsl:attribute name="TopicTextAndImagePosition">				
				<xsl:choose>
					<xsl:when test="$imageLocation=''">urn:mindjet:TextLeftImageRight</xsl:when>
					<xsl:otherwise>urn:mindjet:<xsl:value-of select="$imageLocation"/></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</ap:TopicLayout>
    </xsl:template>
    
</xsl:stylesheet>
