<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html lang="ko">

<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="">
	<meta name="author" content="">
	<tiles:insertTemplate template="/WEB-INF/views/tiles/layouts/defaultHead.jsp" ></tiles:insertTemplate>
	
	<script>
		$(document).ready(function() {
			contW();
			
		})
		$(window).resize(function() {
			
			contW();
		})
		function contW() {
			if ($('div').hasClass('master_pop')) {
				var winW = parent.winW;
				var masterW = parent.masterW;
				var masterIn = parent.masterIn;
				var masterPop = winW - masterIn  - masterW;
				$('.master_body').each(function() {
					$(this).css('padding-right',masterPop);
				})
			}
			
		}
		function layer_close() {
			
			parent.closeLayer();
		}
		function product_close(){
			parent.productSearch_close();	
		}
		
		function  material_close(){
			parent.materialSearch_close();	
		}
		
		function order_close(){
			parent.orderSearch_close();	
		}
		
	</script>
</head>
<body class="layer_body pc">

<tiles:insertAttribute name="content"></tiles:insertAttribute>
	

</body>
</html>
