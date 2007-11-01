Name:           freeipa-python
Version:        0.4.1
Release:        1%{?dist}
Summary:        FreeIPA authentication server

Group:          System Environment/Base
License:        GPL
URL:            http://www.freeipa.org
Source0:        http://www.freeipa.org/downloads/%{name}-%{version}.tgz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch: 	noarch
BuildRequires: python-devel
Requires: PyKerberos

%{!?python_sitelib: %define python_sitelib %(%{__python} -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")}

%define pkgpythondir  %{python_sitelib}/ipa

%description
FreeIPA is a server for identity, policy, and audit.

%prep
%setup -q

%build

%install
rm -rf %{buildroot}
%{__python} setup.py install --no-compile --root=%{buildroot}

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%dir %{pkgpythondir}
%{pkgpythondir}/*
%config(noreplace) %{_sysconfdir}/ipa/ipa.conf

%changelog
* Thu Nov 1 2007 Karl MacMillan <kmacmill@redhat.com> - 0.4.1-1
- Version bump for release

* Wed Oct 17 2007 Rob Crittenden <rcritten@redhat.com> - 0.4.0-2
- Use new python setup.py build script

* Tue Oct  2 2007 Karl MacMillan <kmacmill@redhat.com> - 0.4.0-1
- Milestone 4

* Mon Sep 10 2007 Karl MacMillan <kmacmill@redhat.com> - 0.3.0-1
- Milestone 3

* Fri Aug 17 2007 Karl MacMillan <kmacmill@redhat.com> = 0.2.0-4
- Added PyKerberos dep.

* Mon Aug  5 2007 Rob Crittenden <rcritten@redhat.com> - 0.1.0-3
- Abstracted client class to work directly or over RPC

* Wed Aug  1 2007 Rob Crittenden <rcritten@redhat.com> - 0.1.0-2
- Add User class
- Add kerberos authentication to the XML-RPC request made from tools.

* Fri Jul 27 2007 Karl MacMillan <kmacmill@localhost.localdomain> - 0.1.0-1
- Initial rpm version
