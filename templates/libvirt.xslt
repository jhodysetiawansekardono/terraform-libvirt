<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
  <xsl:output omit-xml-declaration="yes" indent="yes"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="domain">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <qemu:commandline>
      %{ for list in scsi_device_list }
        <qemu:arg value='${list}'/>
      %{ endfor }
      </qemu:commandline>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
