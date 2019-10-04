Imports System.Web.UI
Imports System.Web.UI.WebControls

Partial Public Class Admin_Configure_User_Profile

    Protected Sub btnSave_OnClick(sender As Object, e As EventArgs)
       
        Dim countries As String = String.Join(", ", From item In lstCountryAssignments.Items Select item.Value)

        sqlData_UserProfile.UpdateParameters("Countries").DefaultValue = countries

        sqlData_UserProfile.Update()


    End Sub


End Class
