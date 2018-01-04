locals {
  "group" = "test-pipelines"
}

resource "gocd_pipeline_template" "template-A" {
  name = "template-A"
}

resource "gocd_pipeline" "pipe-A" {
  name      = "pipe-A"
  template  = "${gocd_pipeline_template.template-A.name}"
  group     = "${local.group}"
  materials = [
    {
      type = "git"
      attributes {
        url = "github.com/gocd/gocd"
      }
    }]
}

resource "gocd_pipeline_stage" "stage-A" {
  name     = "stage-A"
  pipeline = "${gocd_pipeline.pipe-A.name}"
  jobs     = [
    "${data.gocd_job_definition.list.json}"]
}

resource "gocd_pipeline_stage" "stage-B" {
  name     = "stage-B"
  pipeline = "${gocd_pipeline.pipe-A.name}"
  jobs     = [
    "${data.gocd_job_definition.list.json}"]
}


data "gocd_job_definition" "list" {
  name  = "list"
  tasks = [
    "${data.gocd_task_definition.list.json}"]
}

data "gocd_task_definition" "list" {
  type    = "exec"
  command = "ls"
}


resource "gocd_pipeline" "pipe-B" {
  name      = "pipe-B"
  template  = "${gocd_pipeline_template.template-A.name}"
  group     = "${local.group}"
  materials = [
    {
      type = "dependency"
      attributes {
        pipeline = "${gocd_pipeline.pipe-A.name}"
        stage    = "${gocd_pipeline_stage.stage-B.name}"
      }
    }]
}