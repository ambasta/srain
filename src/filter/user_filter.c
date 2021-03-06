/* Copyright (C) 2016-2017 Shengyu Zhang <i@silverrainz.me>
 *
 * This file is part of Srain.
 *
 * Srain is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "core/core.h"

#include "srain.h"

#include "./filter.h"

static bool filter(const SrnMessage *msg);

/**
 * @brief user_filter is a filter module for filtering ignored user.
 */
SrnMessageFilter user_filter = {
    .name = "user",
    .filter = filter,
};

bool filter(const SrnMessage *msg) {
    return !(msg->sender->is_ignored || msg->sender->srv_user->is_ignored);
}
