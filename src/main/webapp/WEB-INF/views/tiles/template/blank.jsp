<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<spring:eval expression="@environment.getProperty('ssl.yn')" var="SSL_YN" />
<spring:eval expression="@environment.getProperty('is.prod')" var="IS_PROD" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script>
  var SSL_YN = "${SSL_YN}";
  if (SSL_YN == 'Y' && document.location.protocol == 'http:') {
    document.location.href = document.location.href.replace('http:', 'https:');
  }
</script>
<html xml:lang="ko" xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<%--<tiles:insertTemplate template="/WEB-INF/views/tiles/layouts/defaultHead.jsp"></tiles:insertTemplate>--%>
<body>
<div id="detailContents">
</div>
</body>
</html>
