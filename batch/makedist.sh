export VERSION=3.0b3

# check that schema.sql and updateschema.php agree on schema version
updatenum=`grep 'settings.*allowPaperOption.*=\|update_schema_version' src/updateschema.php | tail -n 1 | sed 's/.*= *//;s/.*[(] *//;s/[;)].*//'`
schemanum=`grep 'allowPaperOption' src/schema.sql | sed 's/.*, *//;s/).*//'`
if [ "$updatenum" != "$schemanum" ]; then
    echo "error: allowPaperOption schema number in src/schema.sql ($schemanum)" 1>&2
    echo "error: differs from number in src/updateschema.php ($updatenum)" 1>&2
    exit 1
fi

# check that HOTCRP_VERSION is up to date -- unless first argument is -n
versionnum=`grep 'HOTCRP_VERSION' src/init.php | head -n 1 | sed 's/.*= "//;s/".*//'`
if [ "$versionnum" != "$VERSION" -a "$1" != "-n" ]; then
    echo "error: HOTCRP_VERSION in src/init.php ($versionnum)" 1>&2
    echo "error: differs from current version ($VERSION)" 1>&2
    exit 1
fi

mkdistdir () {
    crpd=hotcrp-$VERSION
    rm -rf $crpd
    mkdir $crpd

    while read f; do
        if [ -n "$f" ]; then
            d=`echo "$f" | sed 's/[^\/]*$//'`
            [ -n "$d" -a ! -d "$crpd/$d" ] && mkdir "$crpd/$d"
            if [ -f "$f" ]; then
                ln "$f" "$crpd/$f"
            else
                cp -r "$f" "$crpd/$d"
            fi
        fi
    done

    export COPY_EXTENDED_ATTRIBUTES_DISABLE=true COPYFILE_DISABLE=true
    tar --exclude='.DS_Store' --exclude='._*' -czf $crpd.tar.gz $crpd
    rm -rf $crpd
}

mkdistdir <<EOF

.htaccess
.user.ini
LICENSE
NEWS.md
README.md
api.php
assign.php
autoassign.php
bulkassign.php
buzzer.php
cacheable.php
checkupdates.php
conflictassign.php
deadlines.php
doc.php
forgotpassword.php
graph.php
help.php
index.php
log.php
mail.php
manualassign.php
mergeaccounts.php
newaccount.php
oauth.php
offline.php
paper.php
profile.php
resetpassword.php
review.php
reviewprefs.php
scorechart.php
search.php
settings.php
signin.php
signout.php
users.php

batch/.htaccess
batch/assign.php
batch/autoassign.php
batch/backupdb.php
batch/checkinvariants.php
batch/deletepapers.php
batch/fixdelegation.php
batch/killinactivedoc.php
batch/paperjson.php
batch/reviewcsv.php
batch/s3test.php
batch/s3transfer.php
batch/s3verifyall.php
batch/savepapers.php
batch/saveusers.php
batch/search.php
batch/settings.php
batch/updatecontactdb.php

conf/.htaccess

etc/.htaccess
etc/affiliationmatchers.json
etc/apifunctions.json
etc/assignmentparsers.json
etc/autoassigners.json
etc/capabilityhandlers.json
etc/distoptions.php
etc/formulafunctions.json
etc/helptopics.json
etc/intrinsicoptions.json
etc/listactions.json
etc/mailkeywords.json
etc/mailtemplates.json
etc/msgs.json
etc/optiontypes.json
etc/pages.json
etc/papercolumns.json
etc/profilegroups.json
etc/reviewfieldtypes.json
etc/reviewformlibrary.json
etc/sample.pdf
etc/searchkeywords.json
etc/settingdescriptions.md
etc/settinginfo.json
etc/settinggroups.json

lib/.htaccess
lib/abbreviationmatcher.php
lib/archiveinfo.php
lib/backupdb.sh
lib/base.php
lib/cleanhtml.php
lib/collatorshim.php
lib/column.php
lib/countmatcher.php
lib/countries.php
lib/createdb.sh
lib/csv.php
lib/curls3result.php
lib/dbhelper.sh
lib/dbl.php
lib/diff_match_patch.php
lib/dkimsigner.php
lib/filer.php
lib/fmt.php
lib/ftext.php
lib/getopt.php
lib/gmpshim.php
lib/hclcolor.php
lib/ht.php
lib/icons.php
lib/json.php
lib/jsonexception.php
lib/jsonparser.php
lib/jwtparser.php
lib/labcolor.php
lib/ldaplogin.php
lib/login.php
lib/mailer.php
lib/mailpreparation.php
lib/messageset.php
lib/mime.types
lib/mimetext.php
lib/mimetype.php
lib/mincostmaxflow.php
lib/navigation.php
lib/phpqsession.php
lib/polyfills.php
lib/qrequest.php
lib/qsession.php
lib/redirect.php
lib/restoredb.sh
lib/runsql.sh
lib/s3client.php
lib/s3result.php
lib/scoreinfo.php
lib/tagger.php
lib/text.php
lib/unicodehelper.php
lib/xlsx.php

src/.htaccess
src/api/api_alltags.php
src/api/api_assign.php
src/api/api_comment.php
src/api/api_completion.php
src/api/api_decision.php
src/api/api_error.php
src/api/api_events.php
src/api/api_follow.php
src/api/api_formatcheck.php
src/api/api_graphdata.php
src/api/api_mail.php
src/api/api_paper.php
src/api/api_paperpc.php
src/api/api_preference.php
src/api/api_requestreview.php
src/api/api_review.php
src/api/api_reviewtoken.php
src/api/api_search.php
src/api/api_searchconfig.php
src/api/api_session.php
src/api/api_settings.php
src/api/api_taganno.php
src/api/api_tags.php
src/api/api_user.php
src/apihelpers.php
src/assigners/a_conflict.php
src/assigners/a_decision.php
src/assigners/a_error.php
src/assigners/a_follow.php
src/assigners/a_lead.php
src/assigners/a_preference.php
src/assigners/a_review.php
src/assigners/a_status.php
src/assigners/a_tag.php
src/assigners/a_unsubmitreview.php
src/assignmentcountset.php
src/assignmentset.php
src/author.php
src/authormatcher.php
src/autoassigner.php
src/autoassignerinterface.php
src/autoassigners/aa_clear.php
src/autoassigners/aa_discussionorder.php
src/autoassigners/aa_paperpc.php
src/autoassigners/aa_prefconflict.php
src/autoassigners/aa_review.php
src/backuppattern.php
src/banal
src/capabilities/cap_authorview.php
src/capabilities/cap_bearer.php
src/capabilities/cap_reviewaccept.php
src/checkformat.php
src/commentinfo.php
src/componentset.php
src/conference.php
src/confinvariants.php
src/conflict.php
src/contact.php
src/contactcounter.php
src/contactcountmatcher.php
src/contactlist.php
src/contactsearch.php
src/contactset.php
src/decisioninfo.php
src/decisionset.php
src/documentfiletree.php
src/documentinfo.php
src/documentinfoset.php
src/documenthashmatcher.php
src/documentrequest.php
src/fieldrender.php
src/filefilter.php
src/formatspec.php
src/formula.php
src/formulagraph.php
src/formulas/f_author.php
src/formulas/f_conflict.php
src/formulas/f_decision.php
src/formulas/f_now.php
src/formulas/f_optionpresent.php
src/formulas/f_optionvalue.php
src/formulas/f_pdfsize.php
src/formulas/f_pref.php
src/formulas/f_realnumberoption.php
src/formulas/f_reviewer.php
src/formulas/f_reviewermatch.php
src/formulas/f_reviewround.php
src/formulas/f_reviewwordcount.php
src/formulas/f_revtype.php
src/formulas/f_submittedat.php
src/formulas/f_tag.php
src/formulas/f_timefield.php
src/formulas/f_topic.php
src/formulas/f_topicscore.php
src/help/h_bulkassign.php
src/help/h_chairsguide.php
src/help/h_formulas.php
src/help/h_jsonsettings.php
src/help/h_keywords.php
src/help/h_ranking.php
src/help/h_revrate.php
src/help/h_revround.php
src/help/h_scoresort.php
src/help/h_search.php
src/help/h_tags.php
src/help/h_votetags.php
src/helpers.php
src/helprenderer.php
src/hotcrpmailer.php
src/init.php
src/listaction.php
src/listactions/la_assign.php
src/listactions/la_decide.php
src/listactions/la_get.php
src/listactions/la_getabstracts.php
src/listactions/la_getauthors.php
src/listactions/la_getallrevpref.php
src/listactions/la_getdocument.php
src/listactions/la_getjson.php
src/listactions/la_getjsonrqc.php
src/listactions/la_getlead.php
src/listactions/la_getrank.php
src/listactions/la_getpcassignments.php
src/listactions/la_getreviewbase.php
src/listactions/la_getreviewforms.php
src/listactions/la_getreviews.php
src/listactions/la_getreviewcsv.php
src/listactions/la_getscores.php
src/listactions/la_get_sub.php
src/listactions/la_mail.php
src/listactions/la_revpref.php
src/listactions/la_tag.php
src/logentry.php
src/logentryfilter.php
src/mailrecipients.php
src/mailsender.php
src/meetingtracker.php
src/mentionparser.php
src/mergecontacts.php
src/multiconference.php
src/options/o_abstract.php
src/options/o_attachments.php
src/options/o_authors.php
src/options/o_checkboxes.php
src/options/o_checkboxesbase.php
src/options/o_collaborators.php
src/options/o_contacts.php
src/options/o_nonblind.php
src/options/o_numeric.php
src/options/o_pcconflicts.php
src/options/o_realnumber.php
src/options/o_submissionversion.php
src/options/o_title.php
src/options/o_topics.php
src/pages/p_adminhome.php
src/pages/p_api.php
src/pages/p_assign.php
src/pages/p_autoassign.php
src/pages/p_bulkassign.php
src/pages/p_buzzer.php
src/pages/p_cacheable.php
src/pages/p_changeemail.php
src/pages/p_checkupdates.php
src/pages/p_conflictassign.php
src/pages/p_deadlines.php
src/pages/p_doc.php
src/pages/p_graph.php
src/pages/p_graph_formula.php
src/pages/p_graph_procrastination.php
src/pages/p_help.php
src/pages/p_home.php
src/pages/p_log.php
src/pages/p_mail.php
src/pages/p_manualassign.php
src/pages/p_mergeaccounts.php
src/pages/p_oauth.php
src/pages/p_offline.php
src/pages/p_paper.php
src/pages/p_profile.php
src/pages/p_review.php
src/pages/p_reviewprefs.php
src/pages/p_scorechart.php
src/pages/p_search.php
src/pages/p_settings.php
src/pages/p_signin.php
src/pages/p_users.php
src/papercolumn.php
src/papercolumns/pc_administrator.php
src/papercolumns/pc_assignreview.php
src/papercolumns/pc_color.php
src/papercolumns/pc_commenters.php
src/papercolumns/pc_conflict.php
src/papercolumns/pc_conflictmatch.php
src/papercolumns/pc_desirability.php
src/papercolumns/pc_formula.php
src/papercolumns/pc_formulagraph.php
src/papercolumns/pc_lead.php
src/papercolumns/pc_option.php
src/papercolumns/pc_pagecount.php
src/papercolumns/pc_paperidorder.php
src/papercolumns/pc_pcconflicts.php
src/papercolumns/pc_preference.php
src/papercolumns/pc_preferencelist.php
src/papercolumns/pc_reviewdelegation.php
src/papercolumns/pc_reviewerlist.php
src/papercolumns/pc_shepherd.php
src/papercolumns/pc_tag.php
src/papercolumns/pc_tagreport.php
src/papercolumns/pc_timestamp.php
src/papercolumns/pc_topics.php
src/papercolumns/pc_topicscore.php
src/papercolumns/pc_wordcount.php
src/paperevents.php
src/paperexport.php
src/paperinfo.php
src/paperlist.php
src/paperoption.php
src/paperrequest.php
src/papersearch.php
src/paperstatus.php
src/papertable.php
src/paperrank.php
src/papervalue.php
src/permissionproblem.php
src/quicklinksrenderer.php
src/responseround.php
src/reviewdiffinfo.php
src/reviewfield.php
src/reviewfields/rf_checkbox.php
src/reviewfields/rf_checkboxes.php
src/reviewfields/rf_discrete.php
src/reviewfields/rf_text.php
src/reviewfieldsearch.php
src/reviewform.php
src/reviewhistoryinfo.php
src/reviewinfo.php
src/reviewrefusalinfo.php
src/reviewrequestinfo.php
src/reviewsearchmatcher.php
src/reviewtimes.php
src/schema.sql
src/search/st_admin.php
src/search/st_author.php
src/search/st_authormatch.php
src/search/st_badge.php
src/search/st_color.php
src/search/st_comment.php
src/search/st_conflict.php
src/search/st_decision.php
src/search/st_documentcount.php
src/search/st_documentname.php
src/search/st_editfinal.php
src/search/st_emoji.php
src/search/st_formula.php
src/search/st_option.php
src/search/st_optionpresent.php
src/search/st_optiontext.php
src/search/st_optionvalue.php
src/search/st_optionvaluein.php
src/search/st_paperpc.php
src/search/st_paperstatus.php
src/search/st_proposal.php
src/search/st_perm.php
src/search/st_pdf.php
src/search/st_realnumberoption.php
src/search/st_reconflict.php
src/search/st_review.php
src/search/st_reviewtoken.php
src/search/st_revpref.php
src/search/st_sclass.php
src/search/st_tag.php
src/search/st_topic.php
src/searchexample.php
src/searchselection.php
src/searchsplitter.php
src/searchterm.php
src/searchword.php
src/sessionlist.php
src/settinginfoset.php
src/settingparser.php
src/settings/s_automatictag.php
src/settings/s_banal.php
src/settings/s_basics.php
src/settings/s_decision.php
src/settings/s_decisionvisibility.php
src/settings/s_finalversions.php
src/settings/s_json.php
src/settings/s_messages.php
src/settings/s_options.php
src/settings/s_response.php
src/settings/s_review.php
src/settings/s_reviewfieldcondition.php
src/settings/s_reviewform.php
src/settings/s_reviewvisibility.php
src/settings/s_rf.php
src/settings/s_sf.php
src/settings/s_shepherds.php
src/settings/s_sitecontact.php
src/settings/s_sround.php
src/settings/s_subfieldcondition.php
src/settings/s_subform.php
src/settings/s_submissions.php
src/settings/s_tags.php
src/settings/s_tagstyle.php
src/settings/s_topic.php
src/settings/s_track.php
src/settings/s_users.php
src/settingvalues.php
src/si.php
src/siteloader.php
src/sitype.php
src/submissionround.php
src/tagmessagereport.php
src/tagrankparser.php
src/tagsearchmatcher.php
src/textformat.php
src/tokeninfo.php
src/topicset.php
src/track.php
src/updateschema.php
src/updatesession.php
src/useractions.php
src/userinfo/u_developer.php
src/userinfo/u_security.php
src/userstatus.php
src/xtparams.php

devel/hotcrp.vim

images/.htaccess
images/_.gif
images/assign48.png
images/buzzer.mp3
images/check.png
images/comment48.png
images/cross.png
images/edit48.png
images/exassignone.png
images/exsearchaction.png
images/extagcolors.png
images/extagseditkw.png
images/extagssearch.png
images/extagsset.png
images/extagvotehover.png
images/extracker.png
images/generic.png
images/generic24.png
images/genericf.png
images/genericf24.png
images/info45.png
images/pageresultsex.png
images/pdf.png
images/pdf24.png
images/pdff.png
images/pdff24.png
images/pdffx.png
images/pdffx24.png
images/pdfx.png
images/pdfx24.png
images/postscript.png
images/postscript24.png
images/postscriptf.png
images/postscriptf24.png
images/quicksearchex.png
images/review24.png
images/review48.png
images/stophand45.png
images/txt.png
images/txt24.png
images/view48.png
images/viewas.png

scripts/.htaccess
scripts/d3-hotcrp.min.js
scripts/buzzer.js
scripts/emojicodes.json
scripts/graph.js
scripts/jquery-1.12.4.min.js
scripts/jquery-3.6.4.min.js
scripts/script.js
scripts/settings.js

stylesheets/.htaccess
stylesheets/style.css
stylesheets/mobile.css

EOF
