# --------------------------------------------------------------
# Text files under /sandbox are automatically returned...
source ~/cyber_dojo_fs_cleaners.sh

function cyber_dojo_enter()
{
  : # 1. Only return _newly_ generated reports.
  #cyber_dojo_reset_dirs ${...}
}
function cyber_dojo_exit()
{
  : # 2. Remove new text files we don't want returned.
  cyber_dojo_delete_dirs /sandbox/bin 
  cyber_dojo_delete_dirs /sandbox/obj
  cyber_dojo_delete_files TestResult.xml
}
cyber_dojo_enter
trap cyber_dojo_exit EXIT SIGTERM


#FALLBACK, SLOWER ~8.1s: 
# comment in the next line if compilation fails
#time (dotnet restore --source /home/sandbox/.nuget/packages/ && dotnet test --no-restore --nologo ) ; exit

ln -s ~/.nuget/packages/moq/4.20.72/lib/net6.0/Moq.dll Moq.dll
ln -s ~/.nuget/packages/castle.core/5.1.1/lib/net6.0/Castle.Core.dll Castle.Core.dll
ln -s ~/.nuget/packages/nunit/4.3.2/lib/net8.0/nunit.framework.dll nunit.framework.dll

#in order to use legacy asserts eg: AreEqual(42, 42);
# add on top of the .cs file: using static NUnit.Framework.Legacy.ClassicAssert;
ln -s ~/.nuget/packages/nunit/4.3.2/lib/net8.0/nunit.framework.legacy.dll nunit.framework.legacy.dll 

time (dotnet /usr/share/dotnet/sdk/10.0.103/Roslyn/bincore/csc.dll \
  -target:library \
  -nologo \
  -out:dojo.dll \
  -r:nunit.framework.dll \
  -r:Moq.dll \
  -r:Castle.Core.dll \
  -r:nunit.framework.legacy.dll \
  -r:/usr/share/dotnet/shared/Microsoft.NETCore.App/10.0.3/System.Private.CoreLib.dll \
  -r:/usr/share/dotnet/shared/Microsoft.NETCore.App/10.0.3/System.Runtime.dll \
  -r:/usr/share/dotnet/shared/Microsoft.NETCore.App/10.0.3/System.Linq.Expressions.dll \
  -r:/usr/share/dotnet/shared/Microsoft.NETCore.App/10.0.3/System.Linq.dll \
  -r:/usr/share/dotnet/shared/Microsoft.NETCore.App/10.0.3/System.Collections.dll \
  *.cs && /home/sandbox/.dotnet/tools/nunit dojo.dll --noheader --noresult --nocolor )
