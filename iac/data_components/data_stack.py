from aws_cdk import (
    Stack,
    aws_s3 as s3,
    aws_iam as iam,
    aws_glue as glue,
    aws_athena as athena,
    aws_quicksight as quicksight
)
from constructs import Construct


class DataStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        data_lake_bucket = s3.Bucket(
            self,
            "DataBucket"
        )

        athena_bucket = s3.Bucket(
            self,
            "AthenaBucket"
        )

        glue_bucket = s3.Bucket(
            self,
            "GlueBucket"
        )

        glue_role = iam.Role(
            self,
            "GlueRole",
            assumed_by=iam.ServicePrincipal("glue.amazonaws.com"),
            managed_policies=[
                iam.ManagedPolicy.from_aws_managed_policy_name(
                    "service-role/AWSGlueServiceRole")
            ]
        )

        data_lake_bucket.grant_read_write(glue_role)

        cfn_crawler = glue.CfnCrawler(
            self,
            "DataCrawler",
            role=glue_role.role_arn,
            targets=glue.CfnCrawler.TargetsProperty(
                s3_targets=[glue.CfnCrawler.S3TargetProperty(
                    path=f"s3://{data_lake_bucket.bucket_name}/"
                )]
            ),
            database_name="opendata_db"
        )

        # TODO: EMR, QuickSight
