from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

def _data_injection():
    # this funcntion will take care of data injection
    return 13

default_args = {
    'owner': "airflow",
    'retiries': 5,
    'retry_delay': timedelta(minutes=0.5)
}

with DAG(
    dag_id="data_injection",
    default_args=default_args,
    start_date=datetime(2022, 2, 17),
    schedlue_interval="*/5 * * * *",
    catchup=False
) as dag:

    inject_data = PythonOperator(
        task_id="inject_data",
        python_callable=_data_injection
    )




