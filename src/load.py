from typing import Dict

from pandas import DataFrame
from sqlalchemy.engine.base import Engine


def load(data_frames: Dict[str, DataFrame], database: Engine):
    """Load the dataframes into the sqlite database.

    Args:
        data_frames (Dict[str, DataFrame]): A dictionary with keys as the table names
        and values as the dataframes.
    """
    dbapi_connection = database.raw_connection()
    try:
        for table_name, dataframe in data_frames.items():
            print(f"Loading {table_name} into the database...")
            dataframe.to_sql(
                name=table_name,
                con=dbapi_connection,
                if_exists="replace",
                index=False,
            )
        dbapi_connection.commit()
    finally:
        dbapi_connection.close()