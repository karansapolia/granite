import React from "react";
import TableHeader from "./TableHeader";
import TableRow from "./TableRow";

const Table = ({ data, destroyTask, updateTask, showTask }) => {
  return (
    <div className="flex flex-col">
      <div className="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <div className="inline-block min-w-full py-2 align-middle sm:px-6 lg:px-8">
          <div className="overflow-hidden border-b border-bb-gray-200 shadow sm:rounded-lg">
            <table className="min-w-full divide-y divide-gray-200">
              <TableHeader />
              <TableRow
                data={data}
                destroyTask={destroyTask}
                updateTask={updateTask}
                showTask={showTask}
              />
            </table>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Table;
