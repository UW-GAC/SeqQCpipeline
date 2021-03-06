import time
import unittest
import sevenbridges as sbg
import logging
import datetime
from sevenbridges.http.error_handlers import (
    rate_limit_sleeper,
    maintenance_sleeper
)
TASK_TERMINAL_STATES = (
    sbg.TaskStatus.COMPLETED,
    sbg.TaskStatus.ABORTED,
    sbg.TaskStatus.FAILED
)
input_coverage_file = [
    'NWD119836.0005.recab_coverage.txt', 
    'NWD136397.0005.recab_coverage.txt', 
    'NWD176325.0005.recab_coverage.txt',
    'NWD231092.0005.recab_coverage.txt',
    'NWD315403.0005.recab_coverage.txt'
    ]
input_out_prefix = 'unittest'

def reload(*tasks):
    """
    Reload task
    Args:
        *tasks:
    Returns:
    """
    for task in tasks:
        task.reload()
    if len(tasks) == 1:
        return tasks[0]
    return tasks

def wait(*tasks):
    """
    Wait until task is done
    Args:
        *tasks:
    Returns:
    """
    while not all(task.status in TASK_TERMINAL_STATES for task in tasks):
        time.sleep(30)
        reload(*tasks)
    return reload(*tasks)

class Platform(unittest.TestCase):
    """
    Execute platform test
    """
    # enables concurrent execution when run with nosetests
    _multiprocess_shared_ = True
    # for nosetests filtering
    project = None
    execution = "platform"
    profile_name = 'bdc'
    log_filename = 'UnitTest_XYchrom_depth'
    
    @classmethod
    def setUpClass(cls):
        """
        Get input files from the test project and start test task
        Returns:
        """
        # Log file prefix formatting
        prefix_date = str(datetime.datetime.now()).replace(
            ' ', '_'
        ).replace(
            '-', '_'
        )
        logging.basicConfig(
            filename=f'{prefix_date}_{cls.log_filename}.log',
            filemode='a',
            format='%(asctime)s,%(msecs)d %(name)s %(levelname)s %(message)s',
            datefmt='%H:%M:%S',
            level=logging.INFO
        )
        cls.APP = 'smgogarten/qc-for-gwas-development/xy-chromosome-depth'
        cls.inputs = {}
        cls.TASK_NAME = 'UnitTest_XYchromDepth'
        cls.metadata_status = 'fail'
        cls.naming_status = 'fail'
        if not cls.project:
            c = sbg.Config(profile=cls.profile_name)
            print(c)
            cls.session = sbg.Api(
                config=c,
                error_handlers=[
                    rate_limit_sleeper,
                    maintenance_sleeper
                ]
            )
            cls.project_name = 'smgogarten/qc-for-gwas-development'
            # SET INPUTS'
        cls.project = cls.session.projects.get(id=cls.project_name)
        cls.inputs['coverage_file'] = cls.session.files.query(
            names=input_coverage_file,
            project=cls.project
        )
        cls.inputs['out_prefix'] = input_out_prefix
        cls.log = logging.getLogger("#unit_test")
        cls.log.info(f" Starting {cls.APP} test")
        # RUN TASKS
        try:
            cls.task = cls.session.tasks.create(
                name=cls.TASK_NAME,
                project=cls.project,
                app=cls.APP,
                inputs=cls.inputs,
                run=True
            )
            cls.log.info(f" Running {cls.APP} task")
            cls.log.info(f"#task_id {cls.task.id}")
        except:
            cls.log.info(f" I was unable to run {cls.APP} task")
            
    def tearDown(self):
        pass
    
    def test_run_status(self):
        """
        Test workflow execution on the platform
        Returns:
        """
        print(self.project)
        wait(self.task)
        self.log.info(f" Checking {self.APP} status")
        self.log.info(f" Task status {self.task.status}")
        self.assertEqual(self.task.status, 'COMPLETED')
        
    def test_outputs(self):
        """
        Test workflow output file naming
        """
        wait(self.task)
        if self.task.status == 'COMPLETED':
            self.log.info(f" Checking {self.APP} output naming")
            out_expected_name = 'unittest_norm_depth.rds'
            out_name = self.task.outputs['depth'].name
            if out_name.startswith('_'):
                self.assertEqual(out_expected_name, '_'.join(out_name.split('_')[2:]))
            else:
                self.assertEqual(out_expected_name, out_name)
            self.output_status = 'passed'
            self.log.info(f"#output_test {self.output_status}")
            
if __name__ == "__main__":
    unittest.main(testRunner=unittest.TextTestRunner())
