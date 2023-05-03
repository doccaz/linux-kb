<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:strip-space elements="*" />

	<xsl:template match = "@*|node()|processing-instruction()" name="identity">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()|processing-instruction()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="comment()"/>

	<xsl:template match="//answer"><xsl:value-of select="@choice"/>
		<xsl:text>&#09;</xsl:text><xsl:call-template name="identity"/>
	</xsl:template> 

	<xsl:template match="//question">
		<xsl:text>00&#09;</xsl:text><xsl:call-template name="identity"/>
	</xsl:template>

</xsl:stylesheet>
