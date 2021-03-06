#!/usr/bin/perl

use strict;
use warnings;

use Config;
use Cwd;
use Data::Dumper;
use File::Basename;
use File::Copy;
use File::Path qw/make_path/;
use Getopt::Long;
use IPC::Cmd qw/run can_run/;
use Term::ANSIColor;

my %DEFINES = ();

sub parse_defines()
{
   Die("wrong commandline options")
     if ( !GetOptions( "defines=s" => \%DEFINES ) );
}

sub cpy_file($$)
{
   my $src_file = shift;
   my $des_file = shift;

   my $des_dir = dirname($des_file);

   make_path($des_dir)
     if ( !-d $des_dir );

   Die("copy '$src_file' -> '$des_file' failed!")
     if ( !copy( $src_file, $des_file ) );
}

sub git_timestamp_from_dirs($)
{
   my $dirs = shift || [];

   print Dumper($dirs);

   my $ts;
   if ( $dirs && @$dirs )
   {
      foreach my $dir (@$dirs)
      {
         chomp( my $ts_new = `git log --pretty=format:%ct -1 '$dir'` );
         Die("failed to get git timestamp from $dir")
            if(! defined $ts_new);
         $ts = $ts_new
           if ( !defined $ts || $ts_new > $ts );
      }
   }

   return $ts;
}


my %PKG_GRAPH = (
   "zimbra-common-core-libs" => {
      summary   => "Replace zimbra core libs",
      version   => "1.0.0",
      revision  => 1,
      hard_deps => [],
      soft_deps => [],
      other_deps => [ "zimbra-core-components"],
      replaces   => ["zimbra-core"],
      file_list  => ['/opt/zimbra/*'],
      stage_fun  => sub { &stage_zimbra_core_lib(@_); },
   },
   "zimbra-mbox-store-libs" => {
      summary   => "Replace zimbra store libs",
      version   => "1.0.0",
      revision  => 1,
      hard_deps => [],
      soft_deps => [],
      other_deps => [ "zimbra-store-components"],
      replaces   => ["zimbra-store"],
      file_list  => ['/opt/zimbra/*'],
      stage_fun  => sub { &stage_zimbra_store_lib(@_); },
   },

   
);


sub stage_zimbra_core_lib($)
{
   my $stage_base_dir = shift;

        cpy_file("build/dist/ant-1.7.0-ziputil-patched.jar",                        "$stage_base_dir/opt/zimbra/lib/jars/ant-1.7.0-ziputil-patched.jar");
        cpy_file("build/dist/ant-contrib-1.0b2.jar",                                "$stage_base_dir/opt/zimbra/lib/jars/ant-contrib-1.0b2.jar");
        cpy_file("build/dist/ant-tar-patched.jar",                                  "$stage_base_dir/opt/zimbra/lib/jars/ant-tar-patched.jar");
        cpy_file("build/dist/antlr-3.2.jar",                                        "$stage_base_dir/opt/zimbra/lib/jars/antlr-3.2.jar");
        cpy_file("build/dist/apache-jsieve-core-0.5.jar",                           "$stage_base_dir/opt/zimbra/lib/jars/apache-jsieve-core-0.5.jar");
        cpy_file("build/dist/apache-log4j-extras-1.0.jar",                          "$stage_base_dir/opt/zimbra/lib/jars/apache-log4j-extras-1.0.jar");
        cpy_file("build/dist/asm-3.3.1.jar",                                        "$stage_base_dir/opt/zimbra/lib/jars/asm-3.3.1.jar");
        cpy_file("build/dist/bcprov-jdk15-1.46.jar",                                "$stage_base_dir/opt/zimbra/lib/jars/bcprov-jdk15-1.46.jar");
        cpy_file("build/dist/commons-cli-1.2.jar",                                  "$stage_base_dir/opt/zimbra/lib/jars/commons-cli-1.2.jar");
        cpy_file("build/dist/commons-codec-1.7.jar",                                "$stage_base_dir/opt/zimbra/lib/jars/commons-codec-1.7.jar");
        cpy_file("build/dist/commons-collections-3.2.2.jar",                        "$stage_base_dir/opt/zimbra/lib/jars/commons-collections-3.2.2.jar");
        cpy_file("build/dist/commons-compress-1.10.jar",                            "$stage_base_dir/opt/zimbra/lib/jars/commons-compress-1.10.jar");
        cpy_file("build/dist/commons-csv-1.2.jar",                                  "$stage_base_dir/opt/zimbra/lib/jars/commons-csv-1.2.jar");
        cpy_file("build/dist/commons-dbcp-1.4.jar",                                 "$stage_base_dir/opt/zimbra/lib/jars/commons-dbcp-1.4.jar");
        cpy_file("build/dist/commons-fileupload-1.2.2.jar",                         "$stage_base_dir/opt/zimbra/lib/jars/commons-fileupload-1.2.2.jar");
        cpy_file("build/dist/commons-httpclient-3.1.jar",                           "$stage_base_dir/opt/zimbra/lib/jars/commons-httpclient-3.1.jar");
        cpy_file("build/dist/commons-io-1.4.jar",                                   "$stage_base_dir/opt/zimbra/lib/jars/commons-io-1.4.jar");
        cpy_file("build/dist/commons-lang-2.6.jar",                                 "$stage_base_dir/opt/zimbra/lib/jars/commons-lang-2.6.jar");
        cpy_file("build/dist/commons-net-3.3.jar",                                  "$stage_base_dir/opt/zimbra/lib/jars/commons-net-3.3.jar");
        cpy_file("build/dist/commons-pool-1.6.jar",                                 "$stage_base_dir/opt/zimbra/lib/jars/commons-pool-1.6.jar");
        cpy_file("build/dist/concurrentlinkedhashmap-lru-1.3.1.jar",                "$stage_base_dir/opt/zimbra/lib/jars/concurrentlinkedhashmap-lru-1.3.1.jar");
        cpy_file("build/dist/curator-client-2.0.1-incubating.jar",                  "$stage_base_dir/opt/zimbra/lib/jars/curator-client-2.0.1-incubating.jar");
        cpy_file("build/dist/curator-client-2.0.1-incubating.jar",                  "$stage_base_dir/opt/zimbra/lib/jars/curator-client-2.0.1-incubating.jar");
        cpy_file("build/dist/curator-framework-2.0.1-incubating.jar",               "$stage_base_dir/opt/zimbra/lib/jars/curator-framework-2.0.1-incubating.jar");
        cpy_file("build/dist/curator-recipes-2.0.1-incubating.jar",                 "$stage_base_dir/opt/zimbra/lib/jars/curator-recipes-2.0.1-incubating.jar");
        cpy_file("build/dist/curator-x-discovery-2.0.1-incubating.jar",             "$stage_base_dir/opt/zimbra/lib/jars/curator-x-discovery-2.0.1-incubating.jar");
        cpy_file("build/dist/cxf-2.7.18.jar",                                       "$stage_base_dir/opt/zimbra/lib/jars/cxf-2.7.18.jar");
        cpy_file("build/dist/dom4j-1.5.2.jar",                                      "$stage_base_dir/opt/zimbra/lib/jars/dom4j-1.5.2.jar");
        cpy_file("build/dist/freemarker-2.3.19.jar",                                "$stage_base_dir/opt/zimbra/lib/jars/freemarker-2.3.19.jar");
        cpy_file("build/dist/ganymed-ssh2-build210.jar",                            "$stage_base_dir/opt/zimbra/lib/jars/ganymed-ssh2-build210.jar");
        cpy_file("build/dist/gifencoder-0.9.jar",                                   "$stage_base_dir/opt/zimbra/lib/jars/gifencoder-0.9.jar");
        cpy_file("build/dist/gmbal-api-only-2.2.6.jar",                             "$stage_base_dir/opt/zimbra/lib/jars/gmbal-api-only-2.2.6.jar");
        cpy_file("build/dist/guava-13.0.1.jar",                                     "$stage_base_dir/opt/zimbra/lib/jars/guava-13.0.1.jar");
        cpy_file("build/dist/helix-core-0.6.1-incubating.jar",                      "$stage_base_dir/opt/zimbra/lib/jars/helix-core-0.6.1-incubating.jar");
        cpy_file("build/dist/httpasyncclient-4.1.2.jar",                            "$stage_base_dir/opt/zimbra/lib/jars/httpasyncclient-4.1.2.jar");
        cpy_file("build/dist/httpclient-4.5.2.jar",                                 "$stage_base_dir/opt/zimbra/lib/jars/httpclient-4.5.2.jar");
        cpy_file("build/dist/httpcore-4.4.5.jar",                                   "$stage_base_dir/opt/zimbra/lib/jars/httpcore-4.4.5.jar");
        cpy_file("build/dist/httpcore-nio-4.4.5.jar",                               "$stage_base_dir/opt/zimbra/lib/jars/httpcore-nio-4.4.5.jar");
        cpy_file("build/dist/httpmime-4.3.1.jar",                                   "$stage_base_dir/opt/zimbra/lib/jars/httpmime-4.3.1.jar");
        cpy_file("build/dist/ical4j-0.9.16-patched.jar",                            "$stage_base_dir/opt/zimbra/lib/jars/ical4j-0.9.16-patched.jar");
        cpy_file("build/dist/icu4j-4.8.1.1.jar",                                    "$stage_base_dir/opt/zimbra/lib/jars/icu4j-4.8.1.1.jar");
        cpy_file("build/dist/jackson-mapper-asl-1.9.13.jar",                        "$stage_base_dir/opt/zimbra/lib/jars/jackson-mapper-asl-1.9.13.jar");
        cpy_file("build/dist/jackson-core-asl-1.9.13.jar",                          "$stage_base_dir/opt/zimbra/lib/jars/jackson-core-asl-1.9.13.jar");
        cpy_file("build/dist/jackson-xc-1.9.13.jar",                                "$stage_base_dir/opt/zimbra/lib/jars/jackson-xc-1.9.13.jar");
        cpy_file("build/dist/jackson-smile-1.9.13.jar",                             "$stage_base_dir/opt/zimbra/lib/jars/jackson-smile-1.9.13.jar");
        cpy_file("build/dist/jamm-0.2.5.jar",                                       "$stage_base_dir/opt/zimbra/lib/jars/jamm-0.2.5.jar");
        cpy_file("build/dist/javax.servlet-api-3.1.0.jar",                          "$stage_base_dir/opt/zimbra/lib/jars/javax.servlet-api-3.1.0.jar");
        cpy_file("build/dist/javax.ws.rs-api-2.0-m10.jar",                          "$stage_base_dir/opt/zimbra/lib/jars/javax.ws.rs-api-2.0-m10.jar");
        cpy_file("build/dist/jaxb-api-2.2.6.jar",                                   "$stage_base_dir/opt/zimbra/lib/jars/jaxb-api-2.2.6.jar");
        cpy_file("build/dist/jaxb-impl-2.2.6.jar",                                  "$stage_base_dir/opt/zimbra/lib/jars/jaxb-impl-2.2.6.jar");
        cpy_file("build/dist/jaxen-1.1.3.jar",                                      "$stage_base_dir/opt/zimbra/lib/jars/jaxen-1.1.3.jar");
        cpy_file("build/dist/jaxws-api-2.2.6.jar",                                  "$stage_base_dir/opt/zimbra/lib/jars/jaxws-api-2.2.6.jar");
        cpy_file("build/dist/jaxws-rt-2.2.6.jar",                                   "$stage_base_dir/opt/zimbra/lib/jars/jaxws-rt-2.2.6.jar");
        cpy_file("build/dist/jcharset-2.0.jar",                                     "$stage_base_dir/opt/zimbra/lib/jars/jcharset-2.0.jar");
        cpy_file("build/dist/jcommon-1.0.21.jar",                                   "$stage_base_dir/opt/zimbra/lib/jars/jcommon-1.0.21.jar");
        cpy_file("build/dist/jcs-1.3.jar",                                          "$stage_base_dir/opt/zimbra/lib/jars/jcs-1.3.jar");
        cpy_file("build/dist/jdom-1.1.jar",                                         "$stage_base_dir/opt/zimbra/lib/jars/jdom-1.1.jar");
        cpy_file("build/dist/jersey-client-1.11.jar",                               "$stage_base_dir/opt/zimbra/lib/jars/jersey-client-1.11.jar");
        cpy_file("build/dist/jersey-core-1.11.jar",                                 "$stage_base_dir/opt/zimbra/lib/jars/jersey-core-1.11.jar");
        cpy_file("build/dist/jersey-json-1.11.jar",                                 "$stage_base_dir/opt/zimbra/lib/jars/jersey-json-1.11.jar");
        cpy_file("build/dist/jersey-multipart-1.11.jar",                            "$stage_base_dir/opt/zimbra/lib/jars/jersey-multipart-1.11.jar");
        cpy_file("build/dist/jersey-server-1.11.jar",                               "$stage_base_dir/opt/zimbra/lib/jars/jersey-server-1.11.jar");
        cpy_file("build/dist/jersey-servlet-1.11.jar",                              "$stage_base_dir/opt/zimbra/lib/jars/jersey-servlet-1.11.jar");
        cpy_file("build/dist/jfreechart-1.0.15.jar",                                "$stage_base_dir/opt/zimbra/lib/jars/jfreechart-1.0.15.jar");
        cpy_file("build/dist/jna-3.4.0.jar",                                        "$stage_base_dir/opt/zimbra/lib/jars/jna-3.4.0.jar");
        cpy_file("build/dist/jsr181-api-1.0-MR1.jar",                               "$stage_base_dir/opt/zimbra/lib/jars/jsr181-api-1.0-MR1.jar");
        cpy_file("build/dist/jsr311-api-1.1.1.jar",                                 "$stage_base_dir/opt/zimbra/lib/jars/jsr311-api-1.1.1.jar");
        cpy_file("build/dist/junixsocket-common-2.0.4.jar",                         "$stage_base_dir/opt/zimbra/lib/jars/junixsocket-common-2.0.4.jar");
        cpy_file("build/dist/junixsocket-demo-2.0.4.jar",                           "$stage_base_dir/opt/zimbra/lib/jars/junixsocket-demo-2.0.4.jar");
        cpy_file("build/dist/junixsocket-mysql-2.0.4.jar",                          "$stage_base_dir/opt/zimbra/lib/jars/junixsocket-mysql-2.0.4.jar");
        cpy_file("build/dist/junixsocket-rmi-2.0.4.jar",                            "$stage_base_dir/opt/zimbra/lib/jars/junixsocket-rmi-2.0.4.jar");
        cpy_file("build/dist/junixsocket-native-common-2.0.4.jar",                  "$stage_base_dir/opt/zimbra/lib/jars/junixsocket-native-common-2.0.4.jar");
        cpy_file("build/dist/native-lib-loader-2.0.2.jar",                          "$stage_base_dir/opt/zimbra/lib/jars/native-lib-loader-2.0.2.jar");
        cpy_file("build/dist/jython-standalone-2.5.2.jar",                          "$stage_base_dir/opt/zimbra/lib/jars/jython-standalone-2.5.2.jar");
        cpy_file("build/dist/jline-0.9.93.jar",                                     "$stage_base_dir/opt/zimbra/lib/jars/jline-0.9.93.jar");
        cpy_file("build/dist/jzlib-1.0.7.jar",                                      "$stage_base_dir/opt/zimbra/lib/jars/jzlib-1.0.7.jar");
        cpy_file("build/dist/libidn-1.24.jar",                                      "$stage_base_dir/opt/zimbra/lib/jars/libidn-1.24.jar");
        cpy_file("build/dist/log4j-1.2.16.jar",                                     "$stage_base_dir/opt/zimbra/lib/jars/log4j-1.2.16.jar");
        cpy_file("build/dist/lucene-analyzers-3.5.0.jar",                           "$stage_base_dir/opt/zimbra/lib/jars/lucene-analyzers-3.5.0.jar");
        cpy_file("build/dist/lucene-core-3.5.0.jar",                                "$stage_base_dir/opt/zimbra/lib/jars/lucene-core-3.5.0.jar");
        cpy_file("build/dist/lucene-smartcn-3.5.0.jar",                             "$stage_base_dir/opt/zimbra/lib/jars/lucene-smartcn-3.5.0.jar");
        cpy_file("build/dist/mail-1.4.5.jar",                                       "$stage_base_dir/opt/zimbra/lib/jars/mail-1.4.5.jar");
        cpy_file("build/dist/mariadb-java-client-1.1.8.jar",                        "$stage_base_dir/opt/zimbra/lib/jars/mariadb-java-client-1.1.8.jar");
        cpy_file("build/dist/mina-core-2.0.4.jar",                                  "$stage_base_dir/opt/zimbra/lib/jars/mina-core-2.0.4.jar");
        cpy_file("build/dist/neethi-3.0.2.jar",                                     "$stage_base_dir/opt/zimbra/lib/jars/neethi-3.0.2.jar");
        cpy_file("build/dist/nekohtml-1.9.13.1z.jar",                               "$stage_base_dir/opt/zimbra/lib/jars/nekohtml-1.9.13.1z.jar");
        cpy_file("build/dist/oauth-20100527.jar",                                   "$stage_base_dir/opt/zimbra/lib/jars/oauth-20100527.jar");
        cpy_file("build/dist/owasp-java-html-sanitizer-r239.jar",                   "$stage_base_dir/opt/zimbra/lib/jars/owasp-java-html-sanitizer-r239.jar");
        cpy_file("build/dist/policy-2.3.jar",                                       "$stage_base_dir/opt/zimbra/lib/jars/policy-2.3.jar");
        cpy_file("build/dist/slf4j-api-1.6.4.jar",                                  "$stage_base_dir/opt/zimbra/lib/jars/slf4j-api-1.6.4.jar");
        cpy_file("build/dist/slf4j-log4j12-1.6.4.jar",                              "$stage_base_dir/opt/zimbra/lib/jars/slf4j-log4j12-1.6.4.jar");
        cpy_file("build/dist/smack-3.1.0.jar",                                      "$stage_base_dir/opt/zimbra/lib/jars/smack-3.1.0.jar");
        cpy_file("build/dist/smackx-3.1.0.jar",                                     "$stage_base_dir/opt/zimbra/lib/jars/smackx-3.1.0.jar");
        cpy_file("build/dist/smackx-debug-3.2.1.jar",                               "$stage_base_dir/opt/zimbra/lib/jars/smackx-debug-3.2.1.jar");
        cpy_file("build/dist/smackx-jingle-3.2.1.jar",                              "$stage_base_dir/opt/zimbra/lib/jars/smackx-jingle-3.2.1.jar");
        cpy_file("build/dist/spring-aop-3.0.7.RELEASE.jar",                         "$stage_base_dir/opt/zimbra/lib/jars/spring-aop-3.0.7.RELEASE.jar");
        cpy_file("build/dist/spring-asm-3.0.7.RELEASE.jar",                         "$stage_base_dir/opt/zimbra/lib/jars/spring-asm-3.0.7.RELEASE.jar");
        cpy_file("build/dist/spring-beans-3.0.7.RELEASE.jar",                       "$stage_base_dir/opt/zimbra/lib/jars/spring-beans-3.0.7.RELEASE.jar");
        cpy_file("build/dist/spring-context-3.0.7.RELEASE.jar",                     "$stage_base_dir/opt/zimbra/lib/jars/spring-context-3.0.7.RELEASE.jar");
        cpy_file("build/dist/spring-core-3.0.7.RELEASE.jar",                        "$stage_base_dir/opt/zimbra/lib/jars/spring-core-3.0.7.RELEASE.jar");
        cpy_file("build/dist/spring-expression-3.0.7.RELEASE.jar",                  "$stage_base_dir/opt/zimbra/lib/jars/spring-expression-3.0.7.RELEASE.jar");
        cpy_file("build/dist/spymemcached-2.12.1.jar",                              "$stage_base_dir/opt/zimbra/lib/jars/spymemcached-2.12.1.jar");
        cpy_file("build/dist/jedis-2.9.0.jar",                                      "$stage_base_dir/opt/zimbra/lib/jars/jedis-2.9.0.jar");
        cpy_file("build/dist/commons-pool2-2.4.2.jar",                              "$stage_base_dir/opt/zimbra/lib/jars/commons-pool2-2.4.2.jar");
        cpy_file("build/dist/sqlite-jdbc-3.7.15-M1.jar",                            "$stage_base_dir/opt/zimbra/lib/jars/sqlite-jdbc-3.7.15-M1.jar");
        cpy_file("build/dist/stax-ex-1.7.7.jar",                                    "$stage_base_dir/opt/zimbra/lib/jars/stax-ex-1.7.7.jar");
        cpy_file("build/dist/stax2-api-3.1.1.jar",                                  "$stage_base_dir/opt/zimbra/lib/jars/stax2-api-3.1.1.jar");
        cpy_file("build/dist/streambuffer-2.2.6.jar",                               "$stage_base_dir/opt/zimbra/lib/jars/streambuffer-2.2.6.jar");
        cpy_file("build/dist/syslog4j-0.9.46.jar",                                  "$stage_base_dir/opt/zimbra/lib/jars/syslog4j-0.9.46.jar");
        cpy_file("build/dist/unboundid-ldapsdk-2.3.5.jar",                          "$stage_base_dir/opt/zimbra/lib/jars/unboundid-ldapsdk-2.3.5.jar");
        cpy_file("build/dist/woodstox-core-asl-4.2.0.jar",                          "$stage_base_dir/opt/zimbra/lib/jars/woodstox-core-asl-4.2.0.jar");
        cpy_file("build/dist/wsdl4j-1.6.3.jar",                                     "$stage_base_dir/opt/zimbra/lib/jars/wsdl4j-1.6.3.jar");
        cpy_file("build/dist/xercesImpl-2.9.1-patch-01.jar",                        "$stage_base_dir/opt/zimbra/lib/jars/xercesImpl-2.9.1-patch-01.jar");
        cpy_file("build/dist/xmlschema-core-2.0.3.jar",                             "$stage_base_dir/opt/zimbra/lib/jars/xmlschema-core-2.0.3.jar");
        cpy_file("build/dist/yuicompressor-2.4.2-zimbra.jar",                       "$stage_base_dir/opt/zimbra/lib/jars/yuicompressor-2.4.2-zimbra.jar");
        cpy_file("build/dist/zkclient-0.1.0.jar",                                   "$stage_base_dir/opt/zimbra/lib/jars/zkclient-0.1.0.jar");
        cpy_file("build/dist/zookeeper-3.4.5.jar",                                  "$stage_base_dir/opt/zimbra/lib/jars/zookeeper-3.4.5.jar");
        cpy_file("build/dist/zm-ews-stub-2.0.jar",                                  "$stage_base_dir/opt/zimbra/lib/jars/zm-ews-stub-2.0.jar");
        cpy_file("build/dist/ehcache-3.1.2.jar",                                    "$stage_base_dir/opt/zimbra/lib/jars/ehcache-3.1.2.jar");
        cpy_file("build/dist/zimbra-charset.jar",                                   "$stage_base_dir/opt/zimbra/lib/jars/zimbra-charset.jar");
        cpy_file("build/dist/ant-1.6.5.jar",                                        "$stage_base_dir/opt/zimbra/lib/jars/ant-1.6.5.jar");
        cpy_file("build/dist/json-20090211.jar",                                    "$stage_base_dir/opt/zimbra/lib/jars/json.jar");
        cpy_file("build/dist/commons-logging-1.1.1.jar",                            "$stage_base_dir/opt/zimbra/lib/jars/commons-logging.jar");

   
   return ["."];
}


sub stage_zimbra_store_lib($)
{
   my $stage_base_dir = shift;

       cpy_file("build/dist/bcpkix-jdk15on-1.55.jar",                               "$stage_base_dir/opt/zimbra/lib/ext-common/bcpkix-jdk15on-1.55.jar");
       cpy_file("build/dist/bcmail-jdk15on-1.55.jar",                               "$stage_base_dir/opt/zimbra/lib/ext-common/bcmail-jdk15on-1.55.jar");
       cpy_file("build/dist/bcprov-jdk15on-1.55.jar",                               "$stage_base_dir/opt/zimbra/lib/ext-common/bcprov-jdk15on-1.55.jar");
       cpy_file("build/dist/zmzimbratozimbramig-8.7.jar",                           "$stage_base_dir/opt/zimbra/lib/jars/zmzimbratozimbramig.jar");
       cpy_file("build/dist/jcharset-2.0.jar",                                      "$stage_base_dir/opt/zimbra/jetty_base/common/endorsed/jcharset.jar");
       cpy_file("build/dist/zimbra-charset.jar",                                    "$stage_base_dir/opt/zimbra/jetty_base/common/endorsed/zimbra-charset.jar");
       cpy_file("build/dist/apache-log4j-extras-1.0.jar",                           "$stage_base_dir/opt/zimbra/jetty_base/common/lib/apache-log4j-extras-1.0.jar");
       cpy_file("build/dist/bcprov-jdk15on-1.55.jar",                               "$stage_base_dir/opt/zimbra/jetty_base/common/lib/bcprov-jdk15on-1.55.jar");
       cpy_file("build/dist/commons-cli-1.2.jar",                                   "$stage_base_dir/opt/zimbra/jetty_base/common/lib/commons-cli-1.2.jar");
       cpy_file("build/dist/commons-codec-1.7.jar",                                 "$stage_base_dir/opt/zimbra/jetty_base/common/lib/commons-codec-1.7.jar");
       cpy_file("build/dist/commons-collections-3.2.2.jar",                         "$stage_base_dir/opt/zimbra/jetty_base/common/lib/commons-collections-3.2.2.jar");
       cpy_file("build/dist/commons-compress-1.10.jar",                             "$stage_base_dir/opt/zimbra/jetty_base/common/lib/commons-compress-1.10.jar");
       cpy_file("build/dist/commons-dbcp-1.4.jar",                                  "$stage_base_dir/opt/zimbra/jetty_base/common/lib/commons-dbcp-1.4.jar");
       cpy_file("build/dist/commons-fileupload-1.2.2.jar",                          "$stage_base_dir/opt/zimbra/jetty_base/common/lib/commons-fileupload-1.2.2.jar");
       cpy_file("build/dist/commons-httpclient-3.1.jar",                            "$stage_base_dir/opt/zimbra/jetty_base/common/lib/commons-httpclient-3.1.jar");
       cpy_file("build/dist/commons-io-1.4.jar",                                    "$stage_base_dir/opt/zimbra/jetty_base/common/lib/commons-io-1.4.jar");
       cpy_file("build/dist/commons-lang-2.6.jar",                                  "$stage_base_dir/opt/zimbra/jetty_base/common/lib/commons-lang-2.6.jar");
       cpy_file("build/dist/commons-logging-1.1.1.jar",                             "$stage_base_dir/opt/zimbra/jetty_base/common/lib/commons-logging-1.1.1.jar");
       cpy_file("build/dist/commons-net-3.3.jar",                                   "$stage_base_dir/opt/zimbra/jetty_base/common/lib/commons-net-3.3.jar");
       cpy_file("build/dist/commons-pool-1.6.jar",                                  "$stage_base_dir/opt/zimbra/jetty_base/common/lib/commons-pool-1.6.jar");
       cpy_file("build/dist/concurrentlinkedhashmap-lru-1.3.1.jar",                 "$stage_base_dir/opt/zimbra/jetty_base/common/lib/concurrentlinkedhashmap-lru-1.3.1.jar");
       cpy_file("build/dist/dom4j-1.5.2.jar",                                       "$stage_base_dir/opt/zimbra/jetty_base/common/lib/dom4j-1.5.2.jar");
       cpy_file("build/dist/ganymed-ssh2-build210.jar",                             "$stage_base_dir/opt/zimbra/jetty_base/common/lib/ganymed-ssh2-build210.jar");
       cpy_file("build/dist/guava-13.0.1.jar",                                      "$stage_base_dir/opt/zimbra/jetty_base/common/lib/guava-13.0.1.jar");
       cpy_file("build/dist/httpasyncclient-4.1.2.jar",                             "$stage_base_dir/opt/zimbra/jetty_base/common/lib/httpasyncclient-4.1.2.jar");
       cpy_file("build/dist/httpclient-4.5.2.jar",                                  "$stage_base_dir/opt/zimbra/jetty_base/common/lib/httpclient-4.5.2.jar");
       cpy_file("build/dist/httpcore-4.4.5.jar",                                    "$stage_base_dir/opt/zimbra/jetty_base/common/lib/httpcore-4.4.5.jar");
       cpy_file("build/dist/httpcore-nio-4.4.5.jar",                                "$stage_base_dir/opt/zimbra/jetty_base/common/lib/httpcore-nio-4.4.5.jar");
       cpy_file("build/dist/httpmime-4.3.1.jar",                                    "$stage_base_dir/opt/zimbra/jetty_base/common/lib/httpmime-4.3.1.jar");
       cpy_file("build/dist/icu4j-4.8.1.1.jar",                                     "$stage_base_dir/opt/zimbra/jetty_base/common/lib/icu4j-4.8.1.1.jar");
       cpy_file("build/dist/jaxen-1.1.3.jar",                                       "$stage_base_dir/opt/zimbra/jetty_base/common/lib/jaxen-1.1.3.jar");
       cpy_file("build/dist/jcommon-1.0.21.jar",                                    "$stage_base_dir/opt/zimbra/jetty_base/common/lib/jcommon-1.0.21.jar");
       cpy_file("build/dist/jdom-1.1.jar",                                          "$stage_base_dir/opt/zimbra/jetty_base/common/lib/jdom-1.1.jar");
       cpy_file("build/dist/jfreechart-1.0.15.jar",                                 "$stage_base_dir/opt/zimbra/jetty_base/common/lib/jfreechart-1.0.15.jar");
       cpy_file("build/dist/json-20090211.jar",                                     "$stage_base_dir/opt/zimbra/jetty_base/common/lib/json-20090211.jar");
       cpy_file("build/dist/jtnef-1.9.0.jar",                                       "$stage_base_dir/opt/zimbra/jetty_base/common/lib/jtnef-1.9.0.jar");
       cpy_file("build/dist/junixsocket-common-2.0.4.jar",                          "$stage_base_dir/opt/zimbra/jetty_base/common/lib/junixsocket-common-2.0.4.jar");
       cpy_file("build/dist/junixsocket-demo-2.0.4.jar",                            "$stage_base_dir/opt/zimbra/jetty_base/common/lib/junixsocket-demo-2.0.4.jar");
       cpy_file("build/dist/junixsocket-mysql-2.0.4.jar",                           "$stage_base_dir/opt/zimbra/jetty_base/common/lib/junixsocket-mysql-2.0.4.jar");
       cpy_file("build/dist/junixsocket-rmi-2.0.4.jar",                             "$stage_base_dir/opt/zimbra/jetty_base/common/lib/junixsocket-rmi-2.0.4.jar");
       cpy_file("build/dist/jzlib-1.0.7.jar",                                       "$stage_base_dir/opt/zimbra/jetty_base/common/lib/jzlib-1.0.7.jar");
       cpy_file("build/dist/libidn-1.24.jar",                                       "$stage_base_dir/opt/zimbra/jetty_base/common/lib/libidn-1.24.jar");
       cpy_file("build/dist/log4j-1.2.16.jar",                                      "$stage_base_dir/opt/zimbra/jetty_base/common/lib/log4j-1.2.16.jar");
       cpy_file("build/dist/mail-1.4.5.jar",                                        "$stage_base_dir/opt/zimbra/jetty_base/common/lib/mail-1.4.5.jar");
       cpy_file("build/dist/mariadb-java-client-1.1.8.jar",                         "$stage_base_dir/opt/zimbra/jetty_base/common/lib/mariadb-java-client-1.1.8.jar");
       cpy_file("build/dist/oauth-20100527.jar",                                    "$stage_base_dir/opt/zimbra/jetty_base/common/lib/oauth-20100527.jar");
       cpy_file("build/dist/spymemcached-2.12.1.jar",                               "$stage_base_dir/opt/zimbra/jetty_base/common/lib/spymemcached-2.12.1.jar");
       cpy_file("build/dist/unboundid-ldapsdk-2.3.5.jar",                           "$stage_base_dir/opt/zimbra/jetty_base/common/lib/unboundid-ldapsdk-2.3.5.jar");
       cpy_file("build/dist/xercesImpl-2.9.1-patch-01.jar",                         "$stage_base_dir/opt/zimbra/jetty_base/common/lib/xercesImpl-2.9.1-patch-01.jar");
       cpy_file("build/dist/yuicompressor-2.4.2-zimbra.jar",                        "$stage_base_dir/opt/zimbra/jetty_base/common/lib/yuicompressor-2.4.2-zimbra.jar");
       cpy_file("build/dist/ant-1.7.0-ziputil-patched.jar",                         "$stage_base_dir/opt/zimbra/jetty_base/common/lib/ant-1.7.0-ziputil-patched.jar");
       cpy_file("build/dist/ical4j-0.9.16-patched.jar",                             "$stage_base_dir/opt/zimbra/jetty_base/common/lib/ical4j-0.9.16-patched.jar");
       cpy_file("build/dist/nekohtml-1.9.13.1z.jar",                                "$stage_base_dir/opt/zimbra/jetty_base/common/lib/nekohtml-1.9.13.1z.jar");
       cpy_file("build/dist/zmzimbratozimbramig-8.7.jar",                           "$stage_base_dir/opt/zimbra/lib/jars/zmzimbratozimbramig.jar");
       cpy_file("build/dist/jcharset-2.0.jar",                                      "$stage_base_dir/opt/zimbra/jetty_base/common/endorsed/jcharset.jar");
       return ["."];
}


sub make_package($)
{
   my $pkg_name = shift;

   my $pkg_info = $PKG_GRAPH{$pkg_name};

   print Dumper($pkg_info);

   my $stage_fun = $pkg_info->{stage_fun};

   my $stage_base_dir = "build/stage/$pkg_name";

   make_path($stage_base_dir) if ( !-d $stage_base_dir );

   my $timestamp = git_timestamp_from_dirs( &$stage_fun($stage_base_dir) );

   $pkg_info->{_version_ts} = $pkg_info->{version} . ( $timestamp ? ( "." . $timestamp ) : "" );

   my @cmd = (
      "../zm-pkg-tool/pkg-build.pl",
      "--out-type=binary",
      "--pkg-name=$pkg_name",
      "--pkg-version=$pkg_info->{_version_ts}",
      "--pkg-release=$pkg_info->{revision}",
      "--pkg-summary=$pkg_info->{summary}"
   );

   if ( $pkg_info->{file_list} )
   {
      foreach my $expr ( @{ $pkg_info->{file_list} } )
      {
         print "stage_base_dir = $stage_base_dir\n";
         print "expr = $expr\n";

         my $dir_expr = "$stage_base_dir$expr";

         foreach my $entry (`find $dir_expr -type f`)
         {
            chomp($entry);
            $entry =~ s@$stage_base_dir@@;

            push( @cmd, "--pkg-installs=$entry" );
         }
      }
   }

   push( @cmd, @{ [ map { "--pkg-replaces=$_"; } @{ $pkg_info->{replaces} } ] } )                                                              if ( $pkg_info->{replaces} );
   push( @cmd, @{ [ map { "--pkg-depends=$_"; } @{ $pkg_info->{other_deps} } ] } )                                                             if ( $pkg_info->{other_deps} );
   push( @cmd, @{ [ map { "--pkg-depends=$_ (>= $PKG_GRAPH{$_}->{version})"; } @{ $pkg_info->{soft_deps} } ] } )                               if ( $pkg_info->{soft_deps} );
   push( @cmd, @{ [ map { "--pkg-depends=$_ (= $PKG_GRAPH{$_}->{_version_ts}-$PKG_GRAPH{$_}->{revision})"; } @{ $pkg_info->{hard_deps} } ] } ) if ( $pkg_info->{hard_deps} );

   System(@cmd);
}

sub depth_first_traverse_package($)
{
   my $pkg_name = shift;

   my $pkg_info = $PKG_GRAPH{$pkg_name} || Die("package configuration error: '$pkg_name' not found");

   return
     if ( $pkg_info->{_state} && $pkg_info->{_state} eq "BUILT" );

   Die("dependency loop detected...")
     if ( $pkg_info->{_state} && $pkg_info->{_state} eq "BUILDING" );

   $pkg_info->{_state} = 'BUILDING';

   foreach my $dep_pkg_name ( ( sort @{ $pkg_info->{hard_deps} }, sort @{ $pkg_info->{soft_deps} } ) )
   {
      depth_first_traverse_package($dep_pkg_name);
   }

   make_package($pkg_name);

   $pkg_info->{_state} = 'BUILT';
}

sub main
{
   parse_defines();

   # cleanup
   system( "rm", "-rf", "build/stage" );
   foreach my $pkg_name ( sort keys %PKG_GRAPH )
   {
      depth_first_traverse_package($pkg_name);
   }
}

sub System(@)
{
   my $cmd_str = "@_";

   print color('green') . "#: pwd=@{[Cwd::getcwd()]}" . color('reset') . "\n";
   print color('green') . "#: $cmd_str" . color('reset') . "\n";

   $! = 0;
   my ( $success, $error_message, $full_buf, $stdout_buf, $stderr_buf ) = run( command => \@_, verbose => 1 );

   Die( "cmd='$cmd_str'", $error_message )
     if ( !$success );

   return { msg => $error_message, out => $stdout_buf, err => $stderr_buf };
}

sub Run(%)
{
   my %args  = (@_);
   my $chdir = $args{cd};
   my $child = $args{child};

   my $child_pid = fork();

   Die("FAILURE while forking")
     if ( !defined $child_pid );

   if ( $child_pid != 0 )    # parent
   {
      local $?;

      while ( waitpid( $child_pid, 0 ) == -1 ) { }

      Die( "child $child_pid died", einfo($?) )
        if ( $? != 0 );
   }
   else
   {
      Die( "chdir to '$chdir' failed", einfo($?) )
        if ( $chdir && !chdir($chdir) );

      $! = 0;
      &$child;
      exit(0);
   }
}

sub einfo()
{
   my @SIG_NAME = split( / /, $Config{sig_name} );

   return "ret=" . ( $? >> 8 ) . ( ( $? & 127 ) ? ", sig=SIG" . $SIG_NAME[ $? & 127 ] : "" );
}

sub Die($;$)
{
   my $msg  = shift;
   my $info = shift || "";
   my $err  = "$!";

   print "\n";
   print "\n";
   print "=========================================================================================================\n";
   print color('red') . "FAILURE MSG" . color('reset') . " : $msg\n";
   print color('red') . "SYSTEM ERR " . color('reset') . " : $err\n"  if ($err);
   print color('red') . "EXTRA INFO " . color('reset') . " : $info\n" if ($info);
   print "\n";
   print "=========================================================================================================\n";
   print color('red');
   print "--Stack Trace--\n";
   my $i = 1;

   while ( ( my @call_details = ( caller( $i++ ) ) ) )
   {
      print $call_details[1] . ":" . $call_details[2] . " called from " . $call_details[3] . "\n";
   }
   print color('reset');
   print "\n";
   print "=========================================================================================================\n";

   die "END";
}

##############################################################################################

main();


