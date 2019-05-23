<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>客户管理</title>
		<!-- 导入easyui的资源文件 -->
		<script type="text/javascript" src="easyui/jquery.min.js"></script>
		<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
		<script type="text/javascript" src="easyui/locale/easyui-lang-zh_CN.js"></script>
		<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css">
		<link id="themeLink" rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
	</head>
	
	<body>
		<table id="list"></table>
		
		<!-- 工具条 -->
		<div id="tb">
			<a id="addBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">添加</a>
			<a id="editBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">修改</a>
			<a id="removeBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true">删除</a>
		</div>
		
		<!-- 添加客户的编辑窗口 -->
		<div id="win" class="easyui-window" title="客户数据添加"  
		style="width:500px;height:400px"  data-options="iconCls:'icon-save',modal:true,closed:true">
			<form id="editForm" method="post">
				    	<%--提供id隐藏域,用于区分当前表单是执行新增客户的方法，还是修改客户信息的方法 --%>
				    	<input type="hidden" name="id">
					  	客户姓名：<input type="text" name="name" class="easyui-validatebox" data-options="required:true"/><br/>
					  	客户性别：
					  	<input type="radio" name="gender" value="男"/>男
					  	<input type="radio" name="gender" value="女"/>女
					  	<br/>
					  	客户手机：<input type="text" name="telephone" class="easyui-validatebox" data-options="required:true"/><br/>
					  	客户住址：<input type="text" name="address" class="easyui-validatebox" data-options="required:true"/><br/>
				  	<a id="saveBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
			</form> 
		</div>
		
		<script type="text/javascript">
			$(function(){
				$("#list").datagrid({
					//url:后台数据查询地址
					url:"customer/listByPage.action",
					//columns:填充的列的数据
					columns:[[
						{
							//field:后台对象的属性
							field:"id",
							//title:列标题
							title:"客户编号",
							width:100,
							checkbox:true
						},
						{
							field:"name",
							title:"客户姓名",
							width:200
						},
						{
							field:"gender",
							title:"客户性别",
							width:200
						},
						{
							field:"telephone",
							title:"客户电话",
							width:200
						},
						{
							field:"address",
							title:"客户地址",
							width:200
						},
					]],
					
					//显示分页
					pagination:true,
					//工具条
					toolbar:"#tb"
				});
				
				//给添加按钮绑定事件
				$("#addBtn").click(function (){
					//清空表单的数据
					$("#editForm").form("clear");
					//alert("点击了添加按钮");
					$("#win").window("open");
				});
				
				 //保存添加的客户信息
				$("#saveBtn").click(function(){
					alert("点击了保存按钮");
					$("#editForm").form("submit",{
						//url:提交到后台的地址
						 url:"customer/save.action",
						//onSubmit:表单提交前的回调函数，true:提交表单 false:不提交表单
						onSubmit:function(){
							alert("onSubmit:"+$("#editForm").form("validate"));
							//判断表单的验证是否都通过
							return $("#editForm").form("validate");
						},
						//success:服务器执行完毕后的回调函数,data:服务器返回的字符串数据
						success:function(data)
						{
							//要求Controller返回的数据格式：
							//成功：{success:true} 失败{success:false,msg:错误信息}
							alert("jsp success data:");
							alert(data);
							var data = eval('(' + data + ')'); 
							//alert("data.success:"+${res.success});
							if(data.success)
								{
									$.messager.alert("提示","保存成功了");
									//关闭窗口
									$("#win").window("close");
									//刷新datagrid
									$("#list").datagrid("reload");
								}
								
							else
								$.messager.alert("提示","保存失败："+data.msg,"error");
							
						}
					});
					

				}); 
				 
				 
				 //修改客户信息
				 $("#editBtn").click(function(){
					 //判断只能选择一行进行修改
					 //获取list中选中的个数
					 var rows=$("#list").datagrid("getSelections");
					 if(rows.length!=1)
						 {
						 	$.messager.alert("提示","修改操作只能选择一行","warning");
						 	return;
						 }
					 
					 //表单回显,根据选中行的id(rows[0].id)向后台请求customer/findById.action,获取选中行的数据
					 $("#editForm").form("load","customer/findById.action?id="+rows[0].id);
					 
					 //打开编辑窗口
					 $("#win").window("open");
					 
				 });
				 
				 
				 //批量删除客户
				 $("#removeBtn").click(function(){
					 var rows=$("#list").datagrid("getSelections");
					 if(rows.length==0)
						 {
						 	$.messager.alert("提示","删除操作至少选中一行","warning");
						 	reutrn;
						 }
					 
					 // 前端传递给后台的数据格式：id=1&id=2
					 $.messager.confirm("提示","确认删除数据吗？",function(value){
						 // value=true:表示用户确认删除
						 if(value){
							 var idStr="";
							 //执行删除操作
							 //遍历数据
							 $(rows).each(function(i){
								 idStr+="id="+rows[i].id+"&";
							 });
							 //删除最后一个'&'
							 idStr=idStr.substring(0,idStr.length-1);
							 //传递到后台,data为后台传回前端的数据.json表示将返回数据转成json
							 $.post("customer/remove.action",idStr,function(data){
								 
								 if(data.success)
								 {
									 //刷新datagrid
									 $("#list").datagrid("reload");
									 $.messager.alert("提示","删除成功了","info");
								 }
								 else
									 $.messager.alert("提示","删除成失败"+data.msg,"error"); 
							 },"json");
						 }
					 })
					 
				 });
				
				
			});
		
		</script>
	</body>
</html>