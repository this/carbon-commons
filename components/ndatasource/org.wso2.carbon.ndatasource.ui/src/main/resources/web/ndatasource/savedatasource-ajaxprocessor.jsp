<!--
 ~ Copyright (c) 2005-2010, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 ~
 ~ WSO2 Inc. licenses this file to you under the Apache License,
 ~ Version 2.0 (the "License"); you may not use this file except
 ~ in compliance with the License.
 ~ You may obtain a copy of the License at
 ~
 ~    http://www.apache.org/licenses/LICENSE-2.0
 ~
 ~ Unless required by applicable law or agreed to in writing,
 ~ software distributed under the License is distributed on an
 ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 ~ KIND, either express or implied.  See the License for the
 ~ specific language governing permissions and limitations
 ~ under the License.
 -->

<%-- <%@ page import="org.wso2.carbon.ndatasource.core.services.xsd.WSDataSourceMetaInfo"%>--%>
<%@ page import="org.wso2.carbon.ndatasource.ui.NDataSourceAdminServiceClient"%>
<%@ page import="org.wso2.carbon.ndatasource.ui.NDataSourceHelper"%>
<%@ page import="org.wso2.carbon.ndatasource.ui.stub.core.services.xsd.WSDataSourceMetaInfo"%>

<script type="text/javascript" src="global-params.js"></script>
<script type="text/javascript" src="dscommon.js"></script>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:bundle basename="org.wso2.carbon.ndatasource.ui.i18n.Resources">
	<%
		String httpMethod = request.getMethod().toLowerCase();
		if (!"post".equals(httpMethod)) {
			response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
			return;
		}

		NDataSourceAdminServiceClient client;
		String name = "";
		boolean canAdd = true;
		boolean isSystem = false;
		boolean editMode = "true".equals(request.getParameter("editMode"));
		String dsName = request.getParameter("dsName");
		if (dsName != null) {
			try {
				client = NDataSourceAdminServiceClient.getInstance(config, session);
				WSDataSourceMetaInfo dataSourceMetaInformation = NDataSourceHelper
						.createWSDataSourceMetaInfo(request, client);
				name = dataSourceMetaInformation.getName();
				if (!editMode) {
					if (client.getDataSource(name) != null) {
						canAdd = false;
					}

					if (canAdd) {
						client.addDataSource(dataSourceMetaInformation);
					}
				//edit mode
				} else {
					WSDataSourceMetaInfo m = client.getDataSource(name).getDsMetaInfo();
					isSystem = m.getSystem();
					if (!isSystem) {
						client.addDataSource(dataSourceMetaInformation);
					}
				}
				
				if (!canAdd) {%>
					<script type="text/javascript">
						forward("dialog.jsp?message=<%=name%>&type=existing");
					</script>
			<%} else if (isSystem) {%>
				<script type="text/javascript">
					forward("dialog.jsp?type=issystem");
          		</script>
			<%}else {%>
		
		<script type="text/javascript">
			forward("index.jsp?region=region1&item=new_datasource_menu");
    	</script>		
				<%}
			} catch (Throwable e) {
				request.getSession().setAttribute("", e);
	%>
	<script type="text/javascript">
		forward("dialog.jsp?message=<%=e.getMessage()%>&type=error");
    </script>
	<%
		}
			
	} else {
	%>


<script type="text/javascript">
forward("index.jsp?region=region1&item=new_datasource_menu");
</script>

<%} %>
</fmt:bundle>