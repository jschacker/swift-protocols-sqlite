//
// Created by Jeffrey Roberts on 7/18/15.
// Copyright (c) 2015 NimbleNoggin.io. All rights reserved.
//

import Foundation

public class SQLQueryOperation : SQLiteOperation {
    public var groupBy:String?
    public var having:String?
    public var projection:[String]?
    public var sort:String?

    public override init(database: SQLiteDatabase, statementBuilder: SQLStatementBuilder) {
        super.init(database: database, statementBuilder: statementBuilder)
    }

    public func executeQuery() throws -> Cursor {
        guard let table = self.tableName else {
            throw SQLError.MissingTableName
        }

        let statement = self.statementBuilder.buildSelectStatement(table,
                projection: self.projection,
                selection: self.selection,
                groupBy: self.groupBy,
                having: self.having,
                sort: self.sort)
        let hasNamedParameters = self.namedSelectionArgs != nil
        return hasNamedParameters ?
            try(self.database.executeQuery(statement, parameters:self.namedSelectionArgs))
            :
            try(self.database.executeQuery(statement, parameters:self.selectionArgs))
    }
}