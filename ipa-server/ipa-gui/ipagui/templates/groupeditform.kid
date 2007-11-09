<div xmlns:py="http://purl.org/kid/ns#"
  class="simpleroster">

  <form style="display:none" id='deleteform'
    method="post" action="${tg.url('/group/delete')}">
    <input type="hidden" name="dn" value="${value.get('dn')}" />
  </form>

  <form action="${action}" name="${name}" method="${method}" class="tableform"
      onsubmit="preSubmit()" >

          <input type="submit" class="submitbutton" name="submit"
              value="Update Group"/>
          <input type="submit" class="submitbutton" name="submit"
              value="Cancel Edit" />
          <input type="button" class="deletebutton"
                 value="Delete Group"
                 onclick="return confirmDelete();"
                 />


<?python
from ipagui.helpers import ipahelper
?>

  <script type="text/javascript" charset="utf-8"
    src="${tg.url('/static/javascript/dynamicedit.js')}"></script>
  <script type="text/javascript" charset="utf-8"
    src="${tg.url('/tg_widgets/tg_expanding_form_widget/javascript/expanding_form.js')}"></script>

  <?python searchurl = tg.url('/group/edit_search') ?>

  <script type="text/javascript">
    function toggleProtectedFields(checkbox) {
      var gidnumberField = $('form_gidnumber');
      if (checkbox.checked) {
        gidnumberField.disabled = false;
        $('form_editprotected').value = 'true';
      } else {
        gidnumberField.disabled = true;
        $('form_editprotected').value = '';
      }
    }

    function doSearch() {
      $('searchresults').update("Searching...");
      new Ajax.Updater('searchresults',
          '${searchurl}',
          {  asynchronous:true,
             parameters: { criteria: $('criteria').value },
             evalScripts: true });
      return false;
    }

    function confirmDelete() {
      if (confirm("Are you sure you want to delete this group?")) {
        $('deleteform').submit();
      }
      return false;
    }
  </script>

    <div py:for="field in hidden_fields"
      py:replace="field.display(value_for(field), **params_for(field))" 
      />

    <h2 class="formsection">Group Details</h2>
    <table class="formtable" cellpadding="2" cellspacing="0" border="0">
      <tr>
        <th>
          <label class="fieldlabel" for="${group_fields.cns.field_id}"
            py:content="group_fields.cn.label" />:
        </th>
        <td colspan="3">
          <table class="formtable" cellpadding="2" cellspacing="0" border="0" id="${group_fields.cns.field_id}">
            <tbody>
              <?python repetition = 0
                       cn_index = 0
                       cn_error = tg.errors.get('cn')         
              ?>
              <tr py:for="cn in value_for(group_fields.cn)"
                  id="${group_fields.cns.field_id}_${repetition}" 
                  class="${group_fields.cns.field_class}">

                <td py:for="field in group_fields.cns.fields">
                  <span><input class="textfield" type="text" id="${group_fields.cns.field_id}_${repetition}_cn" name="cns-${repetition}.cn" value="${cn}"/></span>
                  <span py:if="cn_error and cn_error[cn_index]" class="fielderror"
                        py:content="tg.errors.get('cn')" />
                </td>
                <?python cn_index = cn_index + 1 ?>
                <td>
                  <a
                  href="javascript:ExpandingForm.removeItem('${group_fields.cns.field_id}_${repetition}')">Remove (-)</a>
                </td>
                <?python repetition = repetition + 1?>
              </tr>
            </tbody>
          </table>
          <a id="${group_fields.cns.field_id}_doclink" href="javascript:ExpandingForm.addItem('${group_fields.cns.field_id}');">Add ( + )</a>
        </td>
      </tr>

      <tr>
        <th>
          <label class="fieldlabel" for="${group_fields.description.field_id}"
            py:content="group_fields.description.label" />:
        </th>
        <td>
          <span py:replace="group_fields.description.display(value_for(group_fields.description))" />
          <span py:if="tg.errors.get('description')" class="fielderror"
              py:content="tg.errors.get('description')" />

        </td>
      </tr>

      <tr>
        <th>
          <label class="fieldlabel" for="${group_fields.gidnumber.field_id}"
            py:content="group_fields.gidnumber.label" />:
        </th>
        <td>
          <span py:replace="group_fields.gidnumber.display(value_for(group_fields.gidnumber))" />
          <span py:if="tg.errors.get('gidnumber')" class="fielderror"
              py:content="tg.errors.get('gidnumber')" />

          <script type="text/javascript">
              document.getElementById('form_gidnumber').disabled = true;
          </script>
        </td>
      </tr>
    </table>

    <div>
      <h2 class="formsection">Group Members</h2>

      <div class="floatlist">
        <div class="floatheader">To Remove:</div>
        <div id="delmembers">
        </div>
      </div>

      <div>
        <?python div_counter = 1 ?>
        <div py:for="member in members" id="member-${div_counter}">
          <?python
          member_dn = member.get('dn')
          member_dn_esc = ipahelper.javascript_string_escape(member_dn)

          member_uid = member.get('uid')
          if member_uid:
              member_name = "%s %s" % (member.get('givenName', ''),
                                     member.get('sn', ''))
              member_descr = "(%s)" % member.get('uid')
              member_type = "user"
          else:
              member_name = member.get('cn')
              member_descr = "[group]"
              member_type = "group"
          member_name_esc = ipahelper.javascript_string_escape(member_name)
          member_descr_esc = ipahelper.javascript_string_escape(member_descr)
          member_type_esc = ipahelper.javascript_string_escape(member_type)
          ?>
          <span id="member-info-${div_counter}"></span>
          <script type="text/javascript">
            renderMemberInfo($('member-info-${div_counter}'),
                         new MemberDisplayInfo('${member_name_esc}',
                                               '${member_descr_esc}',
                                               '${member_type_esc}'));
          </script>
          <a href="#" 
            onclick="removememberHandler(this, '${member_dn_esc}',
                         new MemberDisplayInfo('${member_name_esc}',
                                               '${member_descr_esc}',
                                               '${member_type_esc}'));
                     return false;"
          >remove</a>
          <script type="text/javascript">
            dn_to_member_div_id['${member_dn_esc}'] = "member-${div_counter}";
            member_hash["${member_dn_esc}"] = 1;
          </script>
          <?python
          div_counter = div_counter + 1
          ?>
        </div>
      </div>

    </div>

    <div style="clear:both">
      <h2 class="formsection">Add Members</h2>

      <div class="floatlist">
        <div class="floatheader">To Add:</div>
        <div id="newmembers">
        </div>
      </div>

      <div>
        <div id="search">
          <input id="criteria" type="text" name="criteria"
            onkeypress="return enterDoSearch(event);" />
          <input class="searchbutton" type="button" value="Find"
            onclick="return doSearch();"
          />
        </div>
        <div id="searchresults">
        </div>
      </div>
    </div>
<hr />
          <input type="submit" class="submitbutton" name="submit"
              value="Update Group"/>
          <input type="submit" class="submitbutton" name="submit"
              value="Cancel Edit" />
          <input type="button" class="deletebutton"
                 value="Delete Group"
                 onclick="return confirmDelete();"
                 />
  </form>

  <script type="text/javascript">
    /*
     * This section restores the contents of the add and remove lists
     * dynamically if we have to refresh the page
     */
    if ($('form_dn_to_info_json').value != "") {
      dn_to_info_hash = new Hash($('form_dn_to_info_json').value.evalJSON());
    }

    if ($('form_editprotected').value != "") {
      $('toggleprotected_checkbox').checked = true;
      toggleProtectedFields($('toggleprotected_checkbox'));
    }
  </script>

  <?python
  dnadds = value.get('dnadd', [])
  if not(isinstance(dnadds,list) or isinstance(dnadds,tuple)):
      dnadds = [dnadds]

  dndels = value.get('dndel', [])
  if not(isinstance(dndels,list) or isinstance(dndels,tuple)):
      dndels = [dndels]
  ?>

  <script py:for="dnadd in dnadds">
    <?python
    dnadd_esc = ipahelper.javascript_string_escape(dnadd)
    ?>
    var dn = "${dnadd_esc}";
    var info = dn_to_info_hash[dn];
    var newdiv = addmember(dn, info);
    if (newdiv != null) {
      newdiv.style.display = 'block';
    }
  </script>

  <script py:for="dndel in dndels">
    <?python
    dndel_esc = ipahelper.javascript_string_escape(dndel)
    ?>
    var dn = "${dndel_esc}";
    var info = dn_to_info_hash[dn];
    var newdiv = removemember(dn, info);
    newdiv.style.display = 'block';
    orig_div_id = dn_to_member_div_id[dn]
    $(orig_div_id).style.display = 'none';
  </script>

</div>
