{ stdenv, lib, git, openssl, buildPythonApplication, pytestCheckHook, ps
, fetchPypi, fetchFromGitLab, sudo }:

buildPythonApplication rec {
  pname = "pmbootstrap";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nN4KUP9l3g5Q+QeWr4Fju2GiOyu2f7u94hz/VJlCYdw=";
  };

  repo = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "postmarketOS";
    repo = pname;
    rev = version;
    hash = "sha256-UkgCNob4nazFO8xXyosV+11Sj4yveYBfgh7aw+/6Rlg=";
  };

  pmb_test = "${repo}/test";

  # Tests depend on sudo
  doCheck = stdenv.isLinux;

  nativeCheckInputs = [ pytestCheckHook git openssl ps sudo ];

  # Add test dependency in PATH
  preCheck = "export PYTHONPATH=$PYTHONPATH:${pmb_test}";

  # skip impure tests
  disabledTests = [
    "test_apk_static"
    "test_aportgen"
    "test_aportgen_device_wizard"
    "test_bootimg"
    "test_build_depends_binary_outdated"
    "test_build_depends_high_level"
    "test_build_depends_no_binary_error"
    "test_build_is_necessary"
    "test_build_local_source_high_level"
    "test_build_src_invalid_path"
    "test_can_fast_forward"
    "test_check_build_for_arch"
    "test_chroot_arguments"
    "test_chroot_interactive_shell"
    "test_chroot_interactive_shell_user"
    "test_clean_worktree"
    "test_config_user"
    "test_cross_compile_distcc"
    "test_crossdirect"
    "test_file"
    "test_filter_aport_packages"
    "test_filter_missing_packages_binary_exists"
    "test_filter_missing_packages_invalid"
    "test_filter_missing_packages_pmaports"
    "test_finish"
    "test_folder_size"
    "test_get_apkbuild"
    "test_get_depends"
    "test_get_upstream_remote"
    "test_helpers_lint"
    "test_helpers_package_get_apkindex"
    "test_helpers_repo"
    "test_helpers_ui"
    "test_init_buildenv"
    "test_kconfig_check"
    "test_keys"
    "test_newapkbuild"
    "test_package"
    "test_package_from_aports"
    "test_pkgrel_bump"
    "test_pmbootstrap_status"
    "test_print_checks_git_repo"
    "test_pull"
    "test_qemu_running_processes"
    "test_questions_additional_options"
    "test_questions_bootimg"
    "test_questions_channel"
    "test_questions_keymaps"
    "test_questions_work_path"
    "test_read_config_channel"
    "test_recurse_invalid"
    "test_run_abuild"
    "test_run_core"
    "test_shell_escape"
    "test_skip_already_built"
    "test_switch_to_channel_branch"
    "test_version"
    "test_build_abuild_leftovers"
    "test_get_all_component_names"
    "test_check_config"
    "test_extract_arch"
    "test_extract_version"
    "test_check"
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ git openssl ]}" ];

  meta = with lib; {
    description = "Sophisticated chroot/build/flash tool to develop and install postmarketOS";
    homepage = "https://gitlab.com/postmarketOS/pmbootstrap";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
