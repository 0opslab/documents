# title{slurm - 一款作业管理系统}

```bash
# Submit a new job:
#提交一份新工作：
sbatch job.sh

# List all jobs for a user:
#列出用户的所有工作：
squeue -u user_name

# Cancel a job by id or name:
#通过ID或名称取消作业：
scancel job_id
scancel --name job_name

# List all information for a job:
#列出工作的所有信息：
scontrol show jobid -dd job_id

# Status info for currently running job:
#当前运行作业的状态信息：
sstat --format=AveCPU,AvePages,AveRSS,AveVMSize,JobID -j job_id --allsteps

```