import clearml
task.connect(options)
task.add_requirements('clearml')
# task.set_base_docker(docker,
#                             docker_arguments='--ipc=host -e="CLEARML_AGENT_SKIP_PYTHON_ENV_INSTALL=1"',
#                             docker_setup_bash_script='pip install clearml')
task.execute_remotely(
    queue_name=queue,  # type: Optional[str]
    clone=False,  # type: bool
    exit_process=True  # type: bool
)